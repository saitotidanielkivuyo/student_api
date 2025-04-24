```sql
-- ============================================
-- Table definitions
-- ============================================
CREATE TABLE programs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    registration_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    program_id INTEGER REFERENCES programs(id)
);

CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL,
    program_id INTEGER REFERENCES programs(id),
    year INTEGER NOT NULL,
    semester INTEGER NOT NULL,
    status VARCHAR(10) NOT NULL,
    credits NUMERIC(4,1) NOT NULL
);

-- ============================================
-- Sample data: programs
-- ============================================
INSERT INTO programs (name, code) VALUES 
  ('BSc. Software Engineering', 'SE'),
  ('BSc. Cybersecurity and Digital Forensics Engineering', 'CSDFE'),
  ('BSc. Computer Engineering', 'CE'),
  ('BSc. Computer Networks and Information Security Engineering', 'CNISE'),
  ('BSc. Digital Content and Broadcasting Engineering', 'DCBE');

-- ============================================
-- Sample data: students
-- ============================================
INSERT INTO students (registration_id, first_name, last_name, program_id) VALUES
  ('T21-03-10901', 'Saitoti',   'Kivuyo',    1),
  ('T21-03-10902', 'Jane',      'Mushi',     1),
  ('T21-03-10998', 'Grace',     'Mallya',    1),
  ('T21-03-10967', 'Peter',     'Ngomo',     1),
  ('T21-03-12343', 'Charlie',   'Nyamanga',  1),
  ('T21-03-23442', 'Diana',     'Samson',    2),
  ('T21-03-10904', 'Ethan',     'Mbonde',    2),
  ('T21-03-28704', 'Ashura',    'Nyanda',    5),
  ('T21-03-13234', 'George',    'Mmelo',     3),
  ('T21-03-10934', 'Anna',      'Evans',     4),
  ('T21-03-45361', 'Shama',     'Ramadhani', 4),
  ('T21-03-34348', 'Juliana',   'Mosha',     5),
  ('T21-03-13443', 'Chales',    'Kadinda',   1),
  ('T21-03-24342', 'Omar',      'Kizo',      2),
  ('T21-03-43904', 'Ethaniella','Emanuel',   5),
  ('T21-03-28900', 'Doroth',    'Machemba',  2),
  ('T21-03-03234', 'Pamui',     'Afrika',    3),
  ('T21-03-90943', 'Kingunge',  'Wese',      4),
  ('T21-03-33430', 'Shadrack',  'Kalale',    4);

-- ============================================
-- Data: BSc. Software Engineering subjects
-- (program_id = 1)
-- ============================================
-- Year 1, Semester 1
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Communication Skills',                           'LG 102',   1, 1, 1, 'Core', 7.5),
  ('Principles of Programming Languages',            'CP 111',   1, 1, 1, 'Core', 9.0),
  ('Discrete Mathematics for ICT',                   'MT 1111',  1, 1, 1, 'Core', 7.5),
  ('Development Perspectives',                       'DS 102',   1, 1, 1, 'Core', 7.5),
  ('Linear Algebra for ICT',                         'MT 1117',  1, 1, 1, 'Core', 7.5),
  ('Introduction to Information Technology',         'IT 111',   1, 1, 1, 'Core', 7.5),
  ('Calculus',                                       'MT 1112',  1, 1, 1, 'Core', 7.5),
  ('Mathematical Foundations of Information Security','IA 112',   1, 1, 1, 'Core', 7.5);

-- Year 1, Semester 2
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Introduction to High Level Programming',         'CP 123',   1, 1, 2, 'Core', 9.0),
  ('Numerical Analysis for ICT',                     'MT 1211',  1, 1, 2, 'Core', 7.5),
  ('Introduction to Database Systems',               'CP 121',   1, 1, 2, 'Core', 9.0),
  ('Introduction to Computer Networking',            'CN 121',   1, 1, 2, 'Core', 7.5),
  ('Introduction to Probability and Statistics',     'ST 1210',  1, 1, 2, 'Core', 7.5),
  ('Introduction to Software Engineering',           'CS 123',   1, 1, 2, 'Core', 6.0),
  ('Introduction to IT Security',                    'IA 124',   1, 1, 2, 'Core', 6.0),
  ('Industrial Practical Training I',                'CS 131',   1, 1, 2, 'Core', 9.6);

-- Year 2, Semester 1
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Object Oriented Programming in Java',            'CP 215',   1, 2, 1, 'Core', 9.0),
  ('Computer Networking Protocols',                  'CN 211',   1, 2, 1, 'Core', 9.0),
  ('Introduction to Linux/Unix Systems',             'CP 211',   1, 2, 1, 'Core', 9.0),
  ('Systems Analysis and Design',                    'CP 212',   1, 2, 1, 'Core', 7.5),
  ('Data Structure and Algorithms Analysis',         'CP 213',   1, 2, 1, 'Core', 10.5),
  ('Computer Organization and Architecture I',       'CT 211',   1, 2, 1, 'Core', 9.0),
  ('Computational Theory',                           'CP 214',   1, 2, 1, 'Core', 7.5);

-- Year 2, Semester 2
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Operating Systems',                              'CP 226',   1, 2, 2, 'Core', 9.0),
  ('Internet Programming and Application I',         'CP 221',   1, 2, 2, 'Core', 7.5),
  ('ICT Research Methods',                           'IS 221',   1, 2, 2, 'Core', 7.5),
  ('Open Source Technologies',                       'CP 222',   1, 2, 2, 'Core', 7.5),
  ('Object-Oriented Systems Design',                 'CP 223',   1, 2, 2, 'Core', 7.5),
  ('Database Management Systems',                    'CP 224',   1, 2, 2, 'Core', 7.5),
  ('Software Testing and Quality Assurance',         'CP 225',   1, 2, 2, 'Core', 7.5),
  ('Industrial Practical Training II',               'CS 231',   1, 2, 2, 'Core', 9.6);

-- Year 3, Semester 1
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Computer Graphics',                              'CP 318',   1, 3, 1, 'Core', 9.0),
  ('Mathematical Logic and Formal Semantics',        'MT 3111',  1, 3, 1, 'Core', 7.5),
  ('Internet Programming and Applications II',       'CP 311',   1, 3, 1, 'Core', 9.0),
  ('Python Programming',                             'CP 312',   1, 3, 1, 'Core', 9.0),
  ('Mobile Applications Development',                'CP 313',   1, 3, 1, 'Core', 9.0),
  ('ICT Entrepreneurship',                           'EME 314',  1, 3, 1, 'Core', 7.5),
  ('Embedded Systems I',                             'CT 411',   1, 3, 1, 'Elective', 9.0),
  ('Selected Topics in Software Engineering',        'CP 316',   1, 3, 1, 'Elective', 9.0);

-- Year 3, Semester 2
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Advanced Java Programming',                      'CS 321',   1, 3, 2, 'Core', 9.0),
  ('Distributed Database Systems',                   'CP 321',   1, 3, 2, 'Core', 9.0),
  ('Information and Communication Systems Security', 'IA 321',   1, 3, 2, 'Core', 9.0),
  ('Data Mining and Warehousing',                    'CP 322',   1, 3, 2, 'Core', 9.0),
  ('Web Framework Development Using Javascript',     'CP 323',   1, 3, 2, 'Core', 9.0),
  ('Industrial Practical Training III',              'CS 331',   1, 3, 2, 'Core', 9.6),
  ('Secure System Development',                      'IA 326',   1, 3, 2, 'Elective', 7.5),
  ('Compiler Technology',                            'CP 324',   1, 3, 2, 'Elective', 7.5);

-- Year 4, Semester 1
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Professional Ethics and Conduct',                'SI 311',   1, 4, 1, 'Core', 7.5),
  ('Software Engineering Project I',                 'CS 431',   1, 4, 1, 'Core', 6.0),
  ('Computer Maintenance',                           'CT 312',   1, 4, 1, 'Core', 9.0),
  ('Human-Computer Interaction',                     'IM 411',   1, 4, 1, 'Core', 7.5),
  ('C# Programming',                                 'CP 412',   1, 4, 1, 'Core', 9.0),
  ('Multimedia Content Development',                 'CD 312',   1, 4, 1, 'Core', 7.5),
  ('ICT Project Management',                         'BT 413',   1, 4, 1, 'Core', 6.0),
  ('Electronic and Mobile Commerce',                 'BT 312',   1, 4, 1, 'Elective', 7.5),
  ('Reverse Engineering',                            'CS 411',   1, 4, 1, 'Elective', 7.5),
  ('Foundations of Data Science',                    'CG 222',   1, 4, 1, 'Elective', 7.5);

-- Year 4, Semester 2
INSERT INTO subjects (name, code, program_id, year, semester, status, credits) VALUES
  ('Digital Image Processing',                      'CP 421',   1, 4, 2, 'Core', 7.5),
  ('Software Deployment and Management',            'CS 421',   1, 4, 2, 'Core', 7.5),
  ('Software Engineering Project II',               'CS 432',   1, 4, 2, 'Core', 9.0),
  ('Artificial Intelligence',                       'CP 422',   1, 4, 2, 'Core', 9.0),
  ('System Administration and Management',          'CP 423',   1, 4, 2, 'Core', 9.0),
  ('Cloud Computing',                               'CP 424',   1, 4, 2, 'Core', 9.0),
  ('Embedded Systems II',                           'CT 421',   1, 4, 2, 'Elective', 9.0),
  ('Digital Creative Advertising and Production',   'CD 322',   1, 4, 2, 'Elective', 9.0),
  ('Big Data Analysis',                             'CS 329',   1, 4, 2, 'Elective', 9.0);
```