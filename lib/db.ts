import mysql from 'mysql2/promise';
import { readFileSync } from 'fs';
import { join } from 'path';

const dbConfig = {
  host: process.env.OCEANBASE_HOST || 'localhost',
  port: parseInt(process.env.OCEANBASE_PORT || '3306'),
  user: process.env.OCEANBASE_USER || 'root',
  password: process.env.OCEANBASE_PASSWORD || '',
  database: process.env.OCEANBASE_DATABASE || 'test',
  connectTimeout: 60000,
  ssl: false,
  multipleStatements: false,
};

let connection: mysql.Connection | null = null;
let initialized = false;

async function getConnection(): Promise<mysql.Connection> {
  if (!connection) {
    connection = await mysql.createConnection(dbConfig);
  }
  return connection;
}

function parseSQL(sqlContent: string): string[] {
  return sqlContent
    .split('\n')
    .map(line => line.trim())
    .filter(line => line && !line.startsWith('--'))
    .join('\n')
    .split(';')
    .map(stmt => stmt.trim())
    .filter(stmt => stmt.length > 0);
}

export async function initDatabase(): Promise<void> {
  if (initialized) {
    return;
  }

  try {
    const conn = await getConnection();
    
    let lastError: any = null;
    const maxRetries = 3;
    const retryDelay = 2000;
    
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await conn.execute('SELECT 1');
        lastError = null;
        break;
      } catch (error: any) {
        lastError = error;
        if (attempt < maxRetries) {
          await new Promise(resolve => setTimeout(resolve, retryDelay));
        }
      }
    }
    
    if (lastError) {
      throw lastError;
    }
    
    const sqlPath = join(process.cwd(), 'lib', 'init.sql');
    const sqlContent = readFileSync(sqlPath, 'utf-8');
    const statements = parseSQL(sqlContent);

    for (const statement of statements) {
      if (statement.trim()) {
        try {
          await conn.execute(statement);
        } catch (error: any) {
          if (error.code === 'ER_TABLE_EXISTS_ERROR' || error.code === 'ER_DUP_ENTRY') {
            continue;
          }
          if (error.code === 'ETIMEDOUT' || error.code === 'ECONNREFUSED') {
            throw error;
          }
        }
      }
    }

    initialized = true;
  } catch (error: any) {
    if (error.code !== 'ETIMEDOUT' && error.code !== 'ECONNREFUSED') {
      initialized = true;
    }
    throw error;
  }
}

export async function query<T = any>(
  sql: string,
  params?: any[]
): Promise<T> {
  if (!initialized) {
    try {
      await initDatabase();
    } catch (error: any) {
      if (error.code !== 'ETIMEDOUT' && error.code !== 'ECONNREFUSED') {
        throw error;
      }
    }
  }

  const conn = await getConnection();
  const maxRetries = 2;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const [results] = await conn.execute(sql, params);
      return results as T;
    } catch (error: any) {
      const shouldRetry = (error.code === 'ETIMEDOUT' || error.code === 'ECONNREFUSED' || error.code === 'PROTOCOL_CONNECTION_LOST') && attempt < maxRetries;
      if (shouldRetry) {
        connection = null;
        await new Promise(resolve => setTimeout(resolve, 1000));
        continue;
      }
      throw error;
    }
  }
  
  throw new Error('查询失败');
}

