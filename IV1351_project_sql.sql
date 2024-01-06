/* ------------------------------------------- create tables -------------------- */

/* clear tables */

DROP TABLE IF EXISTS Difficulty_level, Standard_price, Student, Instructor, 
		Guardian_contact_details, Student_sibling, Instrument_type, 
		Instructor_instrument, Rent_instrument_assortment, Rented_instrument, 
		Individual_lesson, Group_lesson, Group_lesson_enrollment, Ensemble_type, 
		Ensemble, Ensemble_enrollment CASCADE;

/* ---------------------- complex order ----------------------- */

/* "difficulty_name" contains: {begginer, intermidate, advanced} */

CREATE TABLE Difficulty_level(
	difficulty_level_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	difficulty_name VARCHAR(50)
);

/* standard prices */

CREATE TABLE Standard_price(
	standard_price_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    sibling_discount INT,
    student_individual_beginner INT,
    student_individual_intermidiate INT,
    student_individual_advanced INT,
    student_group_beginner INT,
    student_group_intermidiate INT,
    student_group_advanced INT,
    student_ensemble INT,
    instructor_individual_beginner INT,
    instructor_individual_intermidiate INT,
    instructor_individual_advanced INT,
    instructor_group_beginner INT,
    instructor_group_intermidiate INT,
    instructor_group_advanced INT,
    instructor_ensemble INT
);

/* ------------------- People ----------------- */

CREATE TABLE Student(
	student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	student_fname VARCHAR(50),
	student_lname VARCHAR(50),
	student_address VARCHAR(50),
	student_mail_address VARCHAR(50),
	student_phone_number VARCHAR(50),
	student_sibling BOOLEAN
);

CREATE TABLE Instructor(
	instructor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_fname VARCHAR(50),
	instructor_lname VARCHAR(50),
	instructor_address VARCHAR(50),
	instructor_mail_address VARCHAR(50),
	instructor_phone_number VARCHAR(50)
);

/* --- details with people ---*/

CREATE TABLE Guardian_contact_details(
	student_id_id INT NOT NULL PRIMARY KEY,
	guardian_fname VARCHAR(50),
	guardian_lname VARCHAR(50),
	guardian_mail_address VARCHAR(50),
	guardian_phone_number VARCHAR(50),

	CONSTRAINT guardian_student FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);

/* student_sibling_group identifies groups of siblings */

CREATE TABLE Student_sibling(
	student_id_id INT NOT NULL PRIMARY KEY,
	student_sibling_group SERIAL,

	CONSTRAINT student_sibling_grouping FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);
	
/* --------------------------- Instrument ---------------------------*/

CREATE TABLE Instrument_type(
	instrument_type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instrument_type_name VARCHAR(50)
);

/* interactions */

CREATE TABLE Instructor_instrument(
	instructor_id_id INT,
	instrument_type_id_id INT,
	difficulty_level_id_id INT,

	CONSTRAINT instructor_instrument FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instructor_instrument_type FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT instructor_instrument_difficulty FOREIGN KEY(difficulty_level_id_id)
        REFERENCES Difficulty_level(difficulty_level_id)
);

CREATE TABLE Rent_instrument_assortment(
	instrument_type_id_id INT PRIMARY KEY NOT NULL,
	instrument_type_stored_quantity INT,
	instrument_type_rent_cost INT
);

CREATE TABLE Rented_instrument(
	student_id_id INT NOT NULL,
	instrument_type_id_id INT NOT NULL,
	rented_instrument_since TIMESTAMP NOT NULL,
	rented_instrument_turned_in TIMESTAMP,

	CONSTRAINT student_renting_instrument FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id),
	CONSTRAINT instructor_instrument_type FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id)
);

/* ------------------------ lesson / ensemble ---------------------- */

/* individual lessons */

CREATE TABLE Individual_lesson(
	individual_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT,
	instrument_type_id_id INT,
	difficulty_level_id_id INT,
	student_id_id INT,
	standard_price_id_id INT,
	individual_lesson_start_time TIMESTAMP NOT NULL,
	individual_lesson_end_time TIMESTAMP,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instrument_type_id_id FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT difficulty_level_id_id FOREIGN KEY(difficulty_level_id_id)
        REFERENCES Difficulty_level(difficulty_level_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id),
	CONSTRAINT standard_price_id_id FOREIGN KEY(STANDARD_PRICE_ID_ID)
		references Standard_price(standard_price_id)
);

/* group lessons */

CREATE TABLE Group_lesson(
	group_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT,
	instrument_type_id_id INT,
	difficulty_level_id_id INT,
	standard_price_id_id INT,
	group_lesson_start_time TIMESTAMP NOT NULL,
	group_lesson_end_time TIMESTAMP,
	group_lesson_student_price INT,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instrument_type_id_id FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT difficulty_level_id_id FOREIGN KEY(difficulty_level_id_id)
        REFERENCES Difficulty_level(difficulty_level_id),
	CONSTRAINT standard_price_id_id FOREIGN KEY(STANDARD_PRICE_ID_ID)
		references Standard_price(standard_price_id)
);

CREATE TABLE Group_lesson_enrollment(
	group_lesson_id_id INT NOT NULL,
	student_id_id INT NOT NULL,

	CONSTRAINT group_lesson_id_id FOREIGN KEY(group_lesson_id_id)
        REFERENCES Group_lesson(group_lesson_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)

);

/* ensembe */

CREATE TABLE Ensemble_type(
	ensemble_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
	ensemble_type_name VARCHAR(50),
	ensemble_description VARCHAR(1000)
);

CREATE TABLE Ensemble(
	ensemble_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT NOT NULL,
	standard_price_id_id INT,
	ensemble_type_id_id INT NOT NULL,
	ensemble_start_time TIMESTAMP NOT NULL,
	ensemble_end_time TIMESTAMP,
	ensemble_instructor_price INT,
	ensemble_max_students INT,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT ensemble_type_id_id FOREIGN KEY(ensemble_type_id_id)
        REFERENCES Ensemble_type(ensemble_type_id),
	CONSTRAINT standard_price_id_id FOREIGN KEY(STANDARD_PRICE_ID_ID)
		references Standard_price(standard_price_id)
);

CREATE TABLE Ensemble_enrollment(
	ensemble_lesson_id_id INT NOT NULL,
	student_id_id INT NOT NULL,

	CONSTRAINT ensemble_lesson_id_id FOREIGN KEY(ensemble_lesson_id_id)
        REFERENCES Ensemble(ensemble_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);
