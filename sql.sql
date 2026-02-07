-- =====================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('admin','teacher','student') NOT NULL,
    avatar TEXT,
    birthday DATE NULL,
    gender ENUM('Nam','Nữ','Khác') NULL,
    address TEXT NULL,
    grade VARCHAR(50) NULL,
    school VARCHAR(255) NULL,
    subject VARCHAR(100) NULL,
    experience INT NULL,
    bio TEXT NULL,
    facebook TEXT NULL,
    instagram TEXT NULL,
    linkedin TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- Bảng Courses
-- =====================================
CREATE TABLE courses (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    subject VARCHAR(100),
    grade VARCHAR(50),
    teacher VARCHAR(100),
    duration VARCHAR(50),
    students INT,
    rating FLOAT,
    price DECIMAL(12,2),
    progress INT,
    is_enrolled BOOLEAN,
    description TEXT,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- Bảng Chapters
-- =====================================
CREATE TABLE chapters (
    id VARCHAR(20) PRIMARY KEY,
    course_id INT,
    title VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- Bảng Lessons
-- =====================================
CREATE TABLE lessons (
    id VARCHAR(20) PRIMARY KEY,
    chapter_id VARCHAR(20),
    title VARCHAR(255),
    duration VARCHAR(50),
    video_url TEXT,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- Bảng Lesson Exercises
-- =====================================
CREATE TABLE lesson_exercises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id VARCHAR(20),
    type ENUM('multiple','boolean','fill'),
    question TEXT,
    options JSON NULL,
    answer TEXT,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- Bảng Lesson Score Comments
-- =====================================
CREATE TABLE lesson_score_comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lesson_id VARCHAR(20) NOT NULL,
    student_id INT NOT NULL,
    total_score DECIMAL(5,2) NOT NULL,
    comment TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- =====================================
-- Bảng Lesson Score Details
-- =====================================
CREATE TABLE lesson_score_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lesson_score_comment_id INT NOT NULL,
    lesson_exercise_id INT NOT NULL,
    student_answer TEXT NULL,
    score DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_score_comment_id) REFERENCES lesson_score_comments(id),
    FOREIGN KEY (lesson_exercise_id) REFERENCES lesson_exercises(id)
);

-- =====================================
-- Bảng Exams
-- =====================================
CREATE TABLE exams (
    id INT PRIMARY KEY,
    course_id INT NULL,
    title VARCHAR(255),
    subject VARCHAR(100),
    type VARCHAR(50),
    date DATE,
    time TIME,
    duration INT,
    status VARCHAR(50),
    total_questions INT,
    max_score INT,
    description TEXT,
    teacher VARCHAR(100),
    classroom VARCHAR(100),
    is_completed BOOLEAN,
    score INT NULL,
    difficulty VARCHAR(50),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- =====================================
-- Bảng Exam Questions
-- =====================================
CREATE TABLE exam_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT,
    question TEXT,
    is_correct BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id)
);

-- =====================================
-- Bảng Score Comments
-- =====================================
CREATE TABLE score_comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    comment TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);


CREATE TABLE course_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,                -- Khóa học được đăng ký
    student_id INT NOT NULL,               -- Học sinh đăng ký
    status ENUM('pending','approved','rejected') DEFAULT 'pending',  -- Trạng thái
    payment_method ENUM('VNPay','Tiền mặt') NOT NULL,  -- Phương thức thanh toán
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);

CREATE TABLE invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id INT NOT NULL,                   -- Liên kết đến đăng ký khóa học
    invoice_number VARCHAR(50) UNIQUE NOT NULL,     -- Mã hóa đơn (sinh tự động)
    amount DECIMAL(12,2) NOT NULL,                  -- Số tiền thanh toán
    payment_method ENUM('VNPay','Tiền mặt') NOT NULL,
    payment_status ENUM('unpaid','paid','cancelled') DEFAULT 'unpaid',
    paid_at TIMESTAMP NULL,                         -- Thời gian thanh toán (nếu có)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Thời gian tạo hóa đơn
    FOREIGN KEY (registration_id) REFERENCES course_registrations(id)
);

CREATE TABLE student_summary_scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,             -- Học sinh
    course_id INT NOT NULL,              -- Khóa học
    final_score DECIMAL(5,2) NOT NULL,   -- Điểm tổng kết
    grade VARCHAR(10) NULL,              -- Xếp loại (A, B, C, D, F)
    comment TEXT NULL,                   -- Nhận xét chung
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
CREATE TABLE student_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,                 -- Học sinh được đánh giá
    course_id INT NOT NULL,                  -- Trong khóa học nào
    teacher_id INT NOT NULL,                 -- Giáo viên đánh giá
    rating INT CHECK (rating BETWEEN 1 AND 5),  -- Điểm đánh giá (1-5 sao)
    feedback TEXT NULL,                      -- Nhận xét chi tiết
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (teacher_id) REFERENCES users(id)
);
