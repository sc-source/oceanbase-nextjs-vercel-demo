import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'OceanBase Course Vercel Demo',
  description: '大学选课后台管理系统演示 - Powered by OceanBase Cloud, Next.js and Vercel',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="zh-CN">
      <body>{children}</body>
    </html>
  );
}
