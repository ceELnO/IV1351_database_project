
/* ---------------------- complex order ----------------------- */

/* "difficulty_name" contains: {begginer, intermidate, advanced} */

CREATE TEMPORARY TABLE Difficulty_level(
	difficulty_level_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	difficulty_name VARCHAR(50)
);

/* ------------------- People ----------------- */

CREATE TEMPORARY TABLE Student(
	student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	student_fname VARCHAR(50),
	student_lname VARCHAR(50),
	student_address VARCHAR(50),
	student_mail_address VARCHAR(50),
	student_phone_number VARCHAR(50),
	student_sibling BOOLEAN
);
CREATE TEMPORARY TABLE Instructor(
	instructor_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_fname VARCHAR(50),
	instructor_lname VARCHAR(50),
	instructor_address VARCHAR(50),
	instructor_mail_address VARCHAR(50),
	instructor_phone_number VARCHAR(50)
);

/* --- details with people ---*/

CREATE TEMPORARY TABLE Guardian_contact_details(
	student_id_id INT NOT NULL,
	guardian_fname VARCHAR(50),
	guardian_lname VARCHAR(50),
	guardian_mail_address VARCHAR(50),
	guardian_phone_number VARCHAR(50),

	CONSTRAINT guardian_student FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);

/* student_sibling_group identifies groups of siblings */

CREATE TEMPORARY TABLE Student_sibling(
	student_id_id INT NOT NULL UNIQUE,
	student_sibling_group SERIAL,

	CONSTRAINT student_sibling_grouping FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);
	
/* --------------------------- Instrument ---------------------------*/

CREATE TEMPORARY TABLE Instrument_type(
	instrument_type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instrument_type_name VARCHAR(50),
	instrument_type_description VARCHAR(1000)
);

/* interactions */

CREATE TEMPORARY TABLE Instructor_instrument(
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

CREATE TEMPORARY TABLE Rent_instrument_assortment(
	instrument_type_id_id INT UNIQUE NOT NULL,
	instrument_type_stored_quantity INT,
	instrument_type_rent_cost INT
);

CREATE TEMPORARY TABLE Rented_instrument(
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

CREATE TEMPORARY TABLE Individual_lesson(
	individual_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT,
	instrument_type_id_id INT,
	difficulty_level_id_id INT,
	student_id_id INT,
	individual_lesson_start_time TIMESTAMP NOT NULL,
	individual_lesson_end_time TIMESTAMP,
	individual_lesson_student_price INT,
	individual_lesson_instructor_price INT,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instrument_type_id_id FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT difficulty_level_id_id FOREIGN KEY(difficulty_level_id_id)
        REFERENCES Difficulty_level(difficulty_level_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);

/* group lessons */

CREATE TEMPORARY TABLE Group_lesson(
	group_lesson_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT,
	instrument_type_id_id INT,
	difficulty_level_id_id INT,
	group_lesson_start_time TIMESTAMP NOT NULL,
	group_lesson_end_time TIMESTAMP,
	group_lesson_student_price INT,
	group_lesson_instructor_price INT,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instrument_type_id_id FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT difficulty_level_id_id FOREIGN KEY(difficulty_level_id_id)
        REFERENCES Difficulty_level(difficulty_level_id)
);

CREATE TEMPORARY TABLE Group_lesson_enrollment(
	group_lesson_id_id INT NOT NULL,
	student_id_id INT NOT NULL,

	CONSTRAINT group_lesson_id_id FOREIGN KEY(group_lesson_id_id)
        REFERENCES Group_lesson(group_lesson_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)

);

/* ensembe */

CREATE TEMPORARY TABLE Ensemble_type(
	ensemble_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
	ensemble_type_name VARCHAR(50),
	ensemble_description VARCHAR(500)
);

CREATE TEMPORARY TABLE Ensemble(
	ensemble_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	instructor_id_id INT NOT NULL,
	instrument_type_id_id INT,
	ensemble_type_id_id INT NOT NULL,
	ensemble_start_time TIMESTAMP NOT NULL,
	ensemble_end_time TIMESTAMP,
	ensemble_student_price INT,
	ensemble_instructor_price INT,

	CONSTRAINT instructor_id_id FOREIGN KEY(instructor_id_id)
        REFERENCES Instructor(instructor_id),
	CONSTRAINT instrument_type_id_id FOREIGN KEY(instrument_type_id_id)
        REFERENCES Instrument_type(instrument_type_id),
	CONSTRAINT ensemble_type_id_id FOREIGN KEY(ensemble_type_id_id)
        REFERENCES Ensemble_type(ensemble_type_id)
);

CREATE TEMPORARY TABLE Ensemble_enrollment(
	ensemble_lesson_id_id INT NOT NULL,
	student_id_id INT NOT NULL,

	CONSTRAINT ensemble_lesson_id_id FOREIGN KEY(ensemble_lesson_id_id)
        REFERENCES Ensemble(ensemble_id),
	CONSTRAINT student_id_id FOREIGN KEY(student_id_id)
        REFERENCES Student(student_id)
);

/* ----------------------- standard prices ------------------------ */

CREATE TEMPORARY TABLE Standard_price(
	standard_price_active BOOLEAN,
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
