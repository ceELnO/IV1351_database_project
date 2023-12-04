/* ------------------------------ insert some base data ------------------------------------ */

/* ------------------ base insertion ------------ */

INSERT INTO Difficulty_level (difficulty_name) VALUES
	('beginner'),
	('intermidate'),
	('advanced');

/* ------------------- People ----------------- */

INSERT INTO Student (student_fname, student_lname, student_address, student_mail_address, student_phone_number) VALUES 
	('John', 'Doe', '123 Main St', 'john@example.com', '123-456-7890'),
	('Jane', 'Smith', '456 Oak Ave', 'jane@example.com', '234-567-8901'),
	('Michael', 'Johnson', '789 Elm St', 'michael@example.com', '345-678-9012'),
	('Emily', 'Williams', '101 Pine St', 'emily@example.com', '456-789-0123'),
	('David', 'Brown', '222 Maple St', 'david@example.com', '567-890-1234'),
	('Sarah', 'Jones', '333 Cedar St', 'sarah@example.com', '678-901-2345'),
	('Matthew', 'Garcia', '444 Birch St', 'matthew@example.com', '789-012-3456'),
	('Olivia', 'Martinez', '555 Walnut St', 'olivia@example.com', '890-123-4567'),
	('Daniel', 'Lopez', '666 Cherry St', 'daniel@example.com', '901-234-5678'),
	('Ava', 'Lee', '777 Spruce St', 'ava@example.com', '012-345-6789');

INSERT INTO Instructor (instructor_fname, instructor_lname, instructor_address, instructor_mail_address, instructor_phone_number) VALUES
	('Robert', 'Johnson', '888 Pine St', 'robert@example.com', '123-456-7890'),
	('Lisa', 'Garcia', '999 Elm St', 'lisa@example.com', '234-567-8901'),
	('William', 'Smith', '111 Oak Ave', 'william@example.com', '345-678-9012');

INSERT INTO Guardian_contact_details (student_id_id, guardian_fname, guardian_lname, guardian_mail_address, guardian_phone_number) VALUES
	(1, 'Mark', 'Johnson', 'mark@example.com', '123-456-7890'),
	(2, 'Laura', 'Garcia', 'laura@example.com', '234-567-8901');

INSERT INTO Student_sibling (student_id_id) VALUES
	(1), (3), (4), (6), (7), (8), (9), (10);

INSERT INTO Student_sibling (student_id_id, student_sibling_group) VALUES
	(2, 1), (5, 3);

/* ---------------------------- Instruments ---------------------- */

INSERT INTO Instrument_type (instrument_type_name, instrument_type_description) VALUES 
	('Guitar', 'A stringed musical instrument usually having six strings played by strumming or plucking.'),
	('Piano', 'A large keyboard musical instrument with a wooden case enclosing a soundboard and metal strings, which are struck by hammers when the keys are depressed.'),
	('Violin', 'A stringed musical instrument of treble pitch, played with a horsehair bow. It is the smallest and highest-pitched member of the violin family of string instruments.');

INSERT INTO Instructor_instrument (instructor_id_id, instrument_type_id_id, difficulty_level_id_id) VALUES
	(1, 1, 3),
	(1, 2, 3),
	(2, 1, 2),
	(2, 3, 1),
	(3, 3, 3),
	(3, 1, 2);

INSERT INTO Rent_instrument_assortment (instrument_type_id_id, instrument_type_stored_quantity, instrument_type_rent_cost) VALUES
	(1, 5, 35),
	(2, 3, 25),
	(3, 4, 50);

INSERT INTO Rented_instrument (student_id_id, instrument_type_id_id, rented_instrument_since) VALUES
	(1, 1, TIMESTAMP '2023-04-03 12:11:00'),
	(1, 2, TIMESTAMP '2023-02-17 15:30:00'),
	(5, 3, TIMESTAMP '2023-04-20 16:02:00'),
	(6, 2, TIMESTAMP '2023-05-24 12:32:00');

/* ---------------------------------- lessons --------------------------- */

-- individual lesson

INSERT INTO Individual_lesson (instructor_id_id, instrument_type_id_id, difficulty_level_id_id, student_id_id, 
	individual_lesson_start_time, individual_lesson_student_price, individual_lesson_instructor_price) VALUES
	(1, 1, 3, 4, TIMESTAMP '2023-04-20 15:30:00', 50, 20),
	(1, 2, 1, 2, TIMESTAMP '2023-02-17 15:30:00', 40, 15),
	(3, 3, 2, 8, TIMESTAMP '2023-07-6 15:30:00', 60, 10),
	(3, 1, 1, 1, TIMESTAMP '2023-07-12 15:30:00', 30, 5),
	(1, 2, 1, 2, TIMESTAMP '2023-09-25 15:30:00', 30, 10);

--- group lesson

INSERT INTO Group_lesson (instructor_id_id, instrument_type_id_id, difficulty_level_id_id,
	group_lesson_start_time, group_lesson_student_price, group_lesson_instructor_price) VALUES
	(2, 1, 1, TIMESTAMP '2023-02-17 13:30:00', 10, 40),
	(2, 3, 1, TIMESTAMP '2023-01-23 12:30:00', 10, 40),
	(1, 2, 2, TIMESTAMP '2023-02-25 13:30:00', 15, 45),
	(3, 3, 2, TIMESTAMP '2023-05-17 17:30:00', 15, 65),
	(1, 1, 3, TIMESTAMP '2023-02-20 16:30:00', 25, 60),
	(2, 3, 1, TIMESTAMP '2023-07-1 12:30:00', 10, 20);

INSERT INTO Group_lesson_enrollment (group_lesson_id_id, student_id_id) VALUES
	(1, 1),
	(1, 3),
	(1, 4),
	(1, 8),
	(2, 4),
	(2, 8),
	(2, 5),
	(2, 1),
	(2, 7),
	(3, 4),
	(3, 5),
	(3, 9),
	(4, 5),
	(4, 7),
	(4, 10),
	(4, 2),
	(5, 3),
	(5, 5),
	(5, 9),
	(6, 7),
	(6, 3),
	(6, 9);

--- ensemble

INSERT INTO Ensemble_type (ensemble_type_name, ensemble_description) VALUES 
	('Chamber Orchestra', 'A small orchestra composed of a limited number of musicians, often performing classical music.'),
	('Jazz Ensemble', 'A musical ensemble that plays jazz music, typically including a combination of brass, woodwind, and rhythm section instruments.'),
	('String Quartet', 'A musical ensemble consisting of four string players - two violin players, a viola player, and a cellist.');

INSERT INTO Ensemble (instructor_id_id, ensemble_type_id_id,
	ensemble_start_time, ensemble_student_price, ensemble_instructor_price, ensemble_max_students) VALUES
	(1, 1, TIMESTAMP '2023-02-23 15:30:00', 10, 20, 10),
	(1, 2, TIMESTAMP '2023-04-12 15:30:00', 15, 20, 15),
	(3, 2, TIMESTAMP '2023-05-4 15:30:00', 15, 20, 12),
	(1, 2, TIMESTAMP '2023-02-21 15:10:00', 10, 20, 12),
	(1, 2, TIMESTAMP '2023-02-22 11:25:00', 12, 22, 8);

INSERT INTO Ensemble_enrollment (ensemble_lesson_id_id, student_id_id) VALUES
	(1, 3),
	(1, 6),
	(1, 3),
	(1, 9),
	(2, 10),
	(2, 2),
	(2, 3),
	(2, 6),
	(2, 1),
	(3, 4),
	(3, 3),
	(4, 2),
	(4, 7),
	(5, 7),
	(5, 1);

/* -------------------------------------- standard prices ----------------------------- */

INSERT INTO Standard_price (standard_price_active, sibling_discount, student_individual_beginner, student_individual_intermidiate,
	student_individual_advanced, student_group_beginner, student_group_intermidiate,
	student_group_advanced, student_ensemble, instructor_individual_beginner,
	instructor_individual_intermidiate, instructor_individual_advanced, instructor_group_beginner, 
	instructor_group_intermidiate, instructor_group_advanced, instructor_ensemble) VALUES
	(TRUE, 10, 30, 40, 50, 10, 15, 20, 20, 20, 25, 30, 30, 35, 40, 50);
