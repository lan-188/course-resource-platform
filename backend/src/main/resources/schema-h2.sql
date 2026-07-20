CREATE TABLE IF NOT EXISTS t_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50),
    role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    class_name VARCHAR(100),
    student_no VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    gender VARCHAR(10),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_course (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(200) NOT NULL,
    description TEXT,
    teacher_id BIGINT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_course_student (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (course_id, student_id)
);

CREATE TABLE IF NOT EXISTS t_experiment_task (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    requirement TEXT,
    teacher_id BIGINT NOT NULL,
    deadline DATETIME,
    status INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_task_file (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    task_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size BIGINT DEFAULT 0,
    file_type VARCHAR(50),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_discussion_post (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    view_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_discussion_comment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS t_submission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    task_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    test_case TEXT,
    defect_report TEXT,
    test_summary TEXT,
    code_text TEXT,
    file_url VARCHAR(500),
    file_path VARCHAR(500),
    file_name VARCHAR(200),
    file_url2 VARCHAR(500),
    file_path2 VARCHAR(500),
    file_name2 VARCHAR(200),
    file_url3 VARCHAR(500),
    file_path3 VARCHAR(500),
    file_name3 VARCHAR(200),
    status INT DEFAULT 0,
    score INT,
    comment TEXT,
    submit_time DATETIME,
    review_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE t_submission ADD COLUMN IF NOT EXISTS code_text TEXT;
ALTER TABLE t_submission ADD COLUMN IF NOT EXISTS file_url VARCHAR(500);
ALTER TABLE t_submission ADD COLUMN IF NOT EXISTS file_path VARCHAR(500);
ALTER TABLE t_submission ADD COLUMN IF NOT EXISTS file_name VARCHAR(200);
ALTER TABLE t_user ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
