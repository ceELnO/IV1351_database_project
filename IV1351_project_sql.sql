
/* ---------------------- complex order ----------------------- */

/* "difficulty_name" contains: {begginer, intermidate, advanced} */

CREATE TABLE Difficulty_level(
	difficulty_level_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	difficulty_name VARCHAR(50)
)

/* ------------------- People ----------------- */

CREATE TABLE Student(
	student_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	student_fname VARCHAR(50),
	student_lname VARCHAR(50),
	student_address VARCHAR(50),
	student_mail_address VARCHAR(50),
	student_phone_number VARCHAR(50),
	studetn_siblings VARCHAR(50)
);
CREATE TABLE Instructor(
	instructor_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_fname VARCHAR(50),
	instructor_lname VARCHAR(50),
	instructor_address VARCHAR(50),
	instructor_mail_address VARCHAR(50),
	instructor_phone_number VARCHAR(50),
);

/* --- details with people ---*/

CREATE TABLE Guardian_contact_details(
	student_id_id INT FOREIGN KEY REFERENCES Student(student_id) NOT NULL,
	guardian_fname VARCHAR(50),
	guardian_lname VARCHAR(50),
	guardian_mail_address VARCHAR(50),
	guardian_phone_number VARCHAR(50)
)

/* student_sibling_group identifies groups of siblings */

CREATE TABLE Student_sibling(
	student_id_id INT FOREIGN KEY REFERENCES Student(student_id) NOT NULL UNIQUE,
	student_sibling_group INT SERIAL
)
	
/* --------------------------- Instrument ---------------------------*/

CREATE TABLE Instrument_type(
	instrument_type_id INT GENERATE ALWAYS AS IDENTITY NOT NULL,
	instrument_type_name VARCHAR(50),
	instrument_type_description VARCHAR(1000)
)

/* interactions */

CREATE TABLE Instructor_instrument(
	instructor_id_id INT FOREIGN KEY REFERENCES Instructor(instrctor_id),
	instrument_type_id_id INT FOREGIN KEY REFERENCES Instrument_type(instrument_type_id_id),
	difficulty_level_id_id INT FOREGIN KEY REFERENCES Difficulty_level(difficulty_level_id)
)

CREATE TABLE Rent_instrument_assortment(
	instrument_type_id_id INT UNIQUE NOT NULL,
	instrument_type_stored_quantity INT,
	instrument_type_rent_cost INT
)

CREATE TABLE Rented_instrument(
	student_id_id INT FOREIGN KEY REFERENCES Student(student_id) NOT NULL,
	insrument_type_id_id INT FOREIGN KEY REFERENCES Instrument_type(instrument_type_id) NOT NULL,
	rented_instrument_since TIMESTAMP NOT NULL,
	rented_instrument_turned_in TIMESTAMP
)

/* ------------------------ lesson / ensemble ---------------------- */

/* individual lessons */

CREATE TABLE Individual_lesson(
	individual_lesson_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT FOREGIN KEY REFERENCES Instrctor(instructor_id),
	instrument_type_id_id INT FOREGIN KEY REFERENCES Instrument_type(instrument_type_id),
	difficulty_level_id_id INT FOREGIN KEY REFERENCES Difficulty_level(difficulty_level_id),
	student_id_id INT FOREGIN KEY REFERENCES Student(student_id),
	individual_lesson_start_time TIMESTAMP,
	individual_lesson_end_time TIMESTAMP,
	individual_lesson_student_price INT,
	individual_lesson_instructor_price INT
)

/* group lessons */

CREATE TABLE group_lesson(
	group_lesson_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT FOREGIN KEY REFERENCES Instrctor(instructor_id),
	instrument_type_id_id INT FOREGIN KEY REFERENCES Instrument_type(instrument_type_id),
	difficulty_level_id_id INT FOREGIN KEY REFERENCES Difficulty_level(difficulty_level_id),
	group_lesson_student_price INT,
	group_lesson_instructor_price INT
)

CREATE TABLE Group_lesson_number_of_places(
	group_lesson_id_id INT FOREIGN KEY REFERENCES group_lesson(group_lesson_id) NOT NULL,
	group_lesson_occurence_start_time TIMESTAMP NOT NULL,
	group_lesson_occurence_end_time TIMESTAMP
)

CREATE TABLE Group_lesson_enrollment(
	group_lesson_id_id INT FOREIGN KEY REFERENCES group_lesson(group_lesson_id) NOT NULL,
	student_id_id INT FOREIGN KEY REFERENCES Student(student_id) NOT NULL
)

/* ensembe */

CREATE TABLE Ensemble_type(
	ensemble_type_id INT PRIMARY KEY GENERATE ALWAYS AS IDENTITY NOT NUL,
	ensemble_type_name VARCHAR(50),
	ensemble_description VARCHAR(500)
)

CREATE TABLE Ensemble(
	ensemble_id INT GENERATE ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT FOREGIN KEY REFERENCES Instrctor(instructor_id),
	instrument_type_id_id INT FOREGIN KEY REFERENCES Instrument_type(instrument_type_id),
	ensemble_type_id_id INT FOREIGN KEY REFERENCES Ensemble_type(ensemble_type_id) NOT NULL,
	ensemble_start_time TIMESTAMP,
	ensemble_end_time TIMESTAMP,
	ensemble_student_price INT,
	ensemble_instructor_price INT
)

CREATE TABLE Group_lesson_enrollment(
	ensemble_lesson_id_id INT FOREIGN KEY REFERENCES ensemble(ensemble_id) NOT NULL,
	student_id_id INT FOREIGN KEY REFERENCES Student(student_id) NOT NULL
)

/* ----------------------- standard prices ------------------------ */

/* Contains the following descriptions: sibling_discount, student_individual_beginner, student_individual_intermidiate, student_individual_advanced, student_group_beginner, student_group_intermidiate, student_group_advanced, student_ensemble, instructor_individual_beginner, instructor_individual_intermidiate, instructor_individual_advanced, instructor_group_beginner, instructor_group_intermidiate, instructor_group_advanced, instructor_ensemble */

CREATE TABLE Standard_price(
	standard_price INT,
	standard_price_description
)