-- UniSelect Course: database initialization

-- Courses table
CREATE TABLE IF NOT EXISTS `courses` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(20) NOT NULL UNIQUE,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `instructor` VARCHAR(100) NOT NULL,
  `department` VARCHAR(100) NOT NULL,
  `credits` INT DEFAULT 3,
  `capacity` INT DEFAULT 30,
  `enrolled` INT DEFAULT 0,
  `semester` VARCHAR(20) DEFAULT 'Fall 2024',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (`code`),
  INDEX idx_department (`department`),
  INDEX idx_semester (`semester`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Course reviews table
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `course_id` INT NOT NULL,
  `student_name` VARCHAR(100) NOT NULL,
  `rating` INT NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
  `comment` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_course_id (`course_id`),
  INDEX idx_rating (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample courses
INSERT INTO `courses` (`code`, `name`, `description`, `instructor`, `department`, `credits`, `capacity`, `enrolled`, `semester`) VALUES
  ('CS101', 'Introduction to Computer Science', 'An introductory course covering fundamental concepts of computer science, programming basics, and problem-solving techniques.', 'Dr. Sarah Johnson', 'Computer Science', 3, 50, 45, 'Fall 2024'),
  ('MATH201', 'Calculus I', 'Differential and integral calculus of functions of one variable. Topics include limits, continuity, derivatives, and integrals.', 'Prof. Michael Chen', 'Mathematics', 4, 40, 38, 'Fall 2024'),
  ('ENG101', 'English Composition', 'Develops writing skills through practice in various forms of composition. Emphasis on clarity, coherence, and effective communication.', 'Dr. Emily Williams', 'English', 3, 35, 32, 'Fall 2024'),
  ('PHYS101', 'General Physics I', 'Mechanics, waves, and thermodynamics. Introduction to the fundamental principles of physics with laboratory work.', 'Prof. David Brown', 'Physics', 4, 45, 42, 'Fall 2024'),
  ('HIST101', 'World History', 'Survey of world history from ancient civilizations to the modern era. Examines major events, cultures, and historical developments.', 'Dr. Lisa Anderson', 'History', 3, 30, 28, 'Fall 2024'),
  ('CHEM101', 'General Chemistry', 'Fundamental principles of chemistry including atomic structure, chemical bonding, and reactions.', 'Prof. Robert Taylor', 'Chemistry', 4, 40, 35, 'Fall 2024'),
  ('BIO101', 'Introduction to Biology', 'Overview of biological principles including cell structure, genetics, evolution, and ecology.', 'Dr. Jennifer Martinez', 'Biology', 4, 50, 48, 'Fall 2024'),
  ('PSY101', 'Introduction to Psychology', 'Survey of major areas of psychology including perception, learning, memory, and social behavior.', 'Prof. James Wilson', 'Psychology', 3, 45, 40, 'Fall 2024')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Sample reviews
INSERT INTO `reviews` (`course_id`, `student_name`, `rating`, `comment`) VALUES
  (1, 'Alice Zhang', 5, 'Excellent course! The instructor explains concepts clearly and the assignments are well-structured. Highly recommend for beginners.'),
  (1, 'Bob Smith', 4, 'Good introduction to CS. Some topics could be explained in more detail, but overall a solid course.'),
  (2, 'Charlie Brown', 5, 'Professor Chen is amazing! Makes calculus understandable and enjoyable. The homework helps reinforce the concepts.'),
  (2, 'Diana Prince', 3, 'Challenging course but fair. The exams are comprehensive but the professor provides good study materials.'),
  (3, 'Edward Norton', 4, 'Great for improving writing skills. The feedback on essays is very helpful.'),
  (4, 'Fiona Apple', 5, 'Love this course! The lab sessions are engaging and the professor is very knowledgeable.'),
  (5, 'George Lucas', 4, 'Interesting overview of world history. The lectures are well-organized and the readings are relevant.'),
  (6, 'Helen Troy', 3, 'Decent chemistry course. Some concepts are difficult but the professor is available for help.'),
  (7, 'Ian Fleming', 5, 'Fascinating introduction to biology. The experiments are hands-on and educational.'),
  (8, 'Jane Doe', 4, 'Good overview of psychology. The case studies make the material more relatable.')
ON DUPLICATE KEY UPDATE `comment`=VALUES(`comment`);
