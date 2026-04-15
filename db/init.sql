CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    professor VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3
);

CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrolled_course_id INT REFERENCES courses(id)
);

-- Seed Data
INSERT INTO courses (name, professor, credits) VALUES 
('Data Structures', 'Dr. Rajesh', 4),
('Compiler Design', 'Dr. Anita', 4),
('Operating Systems', 'Dr. Sunil', 3);

INSERT INTO students (name, email, enrolled_course_id) VALUES 
('Rahul Kumar', 'rahul@nitjsr.ac.in', 1);