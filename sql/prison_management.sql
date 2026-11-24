/* =====================================================================
   Prison Management Database System (Microsoft SQL Server / T-SQL)
   Database Systems course project, The British University in Egypt, 2022.
   Schema, sample data and queries written by Ziad Ayman.
   Run in SSMS or Azure Data Studio: re-creates the Prison database, the
   22 tables with keys and constraints, sample data, then the queries.
   Sample personal data (emails, phone numbers) is fictional/anonymised.
   ===================================================================== */
IF DB_ID('Prison') IS NOT NULL
BEGIN
    ALTER DATABASE Prison SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Prison;
END
GO
CREATE DATABASE Prison;
GO
USE Prison;
GO


create table Control_Room
(
Room_Number int NOT NULL,
CR_Location varchar(200) ,
Work_Start_Time int,
Work_End_Time int ,
Control_Panel varchar (1000),
constraint control_pk
primary key (Room_Number)
);



create table Equipment 
(
Equipment_id int NOT NULL,
Equipment_Name varchar(40) ,
Equipment_Type varchar(100) ,
Equipment_Description varchar(200) ,
Equipment_Price int,
constraint Equipment_pk 
primary key (Equipment_id)
);



create table Prison_Gate
(
Gate_Id int NOT NULL,
Gate_Location varchar(100) ,
Gate_OpeningTime int ,
Gate_ClosingTime int ,
constraint prisongate_pk
primary key (Gate_Id)
);




create table Trasportation 
(
Transportation_id int NOT NULL,
Car_Type varchar(100),
Car_Arriving int ,
Car_Departure int,
constraint Trasportation_pk
primary key (Transportation_id),
);




create table Hall 
(
Hall_Number int NOT NULL,
Hall_Location varchar(30) ,
Capacity int , 
Starting_Time int , 
Ending_Time int ,
constraint Hall_pk
primary key (Hall_Number)
);



create table Supplies	
(
Supplie_Id int NOT NULL,
Supplie_Type varchar(100),
Supplie_Price int,
Recieving_Time smalldatetime ,
Date_of_Expire date ,
constraint Supplies_pk 
primary key (Supplie_Id)
);


create table Food
(
Food_type varchar(20),
F_Id int,
constraint Food_pk
primary key (F_Id),
constraint Food_fk
foreign key (F_Id) references Hall(Hall_Number)
);


create table visit 
(
V_Id int,
Visit_Item varchar(20),
constraint visit_pk
primary key (V_Id),
constraint visit_fk
foreign key (V_Id) references Hall(Hall_Number)
);



create table Cell 
(
Cell_Number int NOT NULL, 
Room_No int,
Cell_Capacity int ,
Cell_Location varchar(200) ,
Cell_Opening_Time int , 
Cell_Closing_Time int  ,
constraint cell_pk
primary key (Cell_Number),
constraint cell_fk
foreign key (Room_No) references Control_Room(Room_Number)
);


create table Activity 
(
Hall_num int,
Activity_id int NOT NULL,
Activity_Name varchar(100) ,
Activity_Location varchar(200),
Activity_StartingTime int  ,
Activity_EndingTime int ,
constraint Activity_pk
primary key (Activity_id,Hall_num),
constraint Activity_fk1
foreign key (Hall_num) references Hall(Hall_Number)
);




CREATE TABLE Prisoner
(
P_Id   INT ,
C_Id int,
A_Id int,
F_Name   varchar(20) NOT NULL,
L_Name   varchar(20) NOT NULL,
Arrival_Time   SMALLDATETIME   ,
Health_Description   Varchar(100),
Health_Status    Varchar(50),
P_Nationality    VARCHAR(20),
P_Photo     VARBINARY,
P_Fingerprint   VARBINARY,
P_Religion     VARCHAR(20),
Past_Job    VARCHAR(50),
Departure_Time   datetime,
constraint Prisoner_pk 
primary key (P_Id)
);


create table Crime 
(
Pr_Id int,
Crime_Code int NOT NULL,
Crime_Name varchar(20),
Crime_Time smalldatetime,
Crime_Location varchar(40),
Crime_Description varchar(100),
Crime_Degree varchar(40),
constraint crime_pk
primary key (Crime_Code),
constraint crime_fk
foreign key (Pr_Id) references Prisoner(P_Id)
);



create table Visitor 
(
Pr_Id int,
V_Id int NOT NULL,
F_Name varchar(15) ,
L_Name varchar(15) ,
V_Job varchar(40) ,
V_Gender char ,
V_Religion varchar(100) ,
V_DOB date , 
V_State varchar(20) ,
Zip_Code int ,
Street_Name varchar (50),
constraint Visitor_pk 
primary key (V_Id),
constraint Visitor_fk
foreign key (Pr_Id) references Prisoner(P_Id)
);



create table Transport_by
(
Transportation_cost int,
pr_id int ,
T_id int,
constraint Transportby_pk
primary key (pr_id,T_id ),
constraint Transportby_fk1
foreign key (pr_id) references Prisoner(P_id),
constraint Transportby_fk2
foreign key (T_id ) references Trasportation(Transportation_id)
);



create table Staff 
(
G_Id int not null,
Super_Ssn int,
Staff_Id int NOT NULL,
F_Name varchar(20) ,
L_Name varchar(20) ,
Gender char ,
E_Mail varchar(40) ,
Phone_No int , 
S_DOB date ,
Street_Name varchar(30) ,
Zip_Code int ,
Job_Description varchar(200) ,
Salary int, 
constraint staff_pk
primary key (Staff_Id ),
constraint staff_fk
foreign key (Super_Ssn) references Staff(Staff_Id),
constraint staff_fk2
foreign key (G_Id) references Prison_Gate (Gate_Id)
);



create table Guard
(
Guard_Id int,
Shift_start int,
Shift_end int,
constraint guard_pk 
primary key (Guard_Id),
constraint guard_fk 
foreign key (Guard_Id) references Staff(Staff_id)
);



create table Utilize
(
reason_of_usage varchar(50),
E_Id int,
S_ID int,
constraint Utilize_pk 
primary key (E_Id,S_ID),
constraint Utilize_fk
foreign key (E_Id) references Equipment(Equipment_id),
constraint Utilize_fk2
foreign key (S_ID) references Staff(Staff_id)
);


create table Supervise
(
Cell_NO int,
S_ID int,
s_starttime int,
s_endtime int,
constraint supervise_pk
primary key (Cell_NO,S_ID),
constraint supervise_fk1 
foreign key (Cell_NO) references Cell(Cell_Number),
constraint supervise_fk2 
foreign key (S_ID) references Staff(Staff_id)
);



create table staff_Phone
(
Stph_Id int,
Phone_Number int
constraint staff_Phone_pk
primary key (Stph_Id,Phone_Number),
constraint staff_Phone_fk
foreign key (Stph_Id) references Staff(Staff_id)
);



create table Remand 
(
Pr_Id int ,
Remand_No int NOT NULL,
Remand_Size varchar(100),
Remand_Start_Time SMALLDATETIME,
Remand_End_Time SMALLDATETIME,
Remand_Reason varchar(100),
constraint remand_pk
primary key (Remand_No),
constraint remand_fk
foreign key (Pr_Id) references Prisoner(P_Id)

);




create table Manage
(
S_ID int,
R_no int,
M_starttime int,
M_endtime int,
constraint Manage_pk 
primary key (S_ID,R_no),
constraint Manage_fk1
foreign key (S_ID) references Staff(Staff_id),
);

alter table Manage
Add constraint Manage_foreign2
foreign key (R_no) references Remand(Remand_No);


create table Require
(
St_Id int,
Sup_Id int,
Reason_of_requirment varchar(50),
constraint Require_pk 
primary key (St_Id,Sup_Id),
constraint Require_fk1
foreign key (Sup_Id) references Supplies(Supplie_Id),
constraint Require_fk2
foreign key (St_Id) references Staff(Staff_id)

);



insert into Prisoner (A_Id,P_id,F_Name,L_Name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('3','1','Ziad','Ayman','2022/11/28 ','N/A','good','Egyption','muslim','Programmer',' 2023/01/01');
insert into Prisoner (A_Id,P_id,F_name,L_name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('1','2','Mohamed  ','khairi',' 2020/11/01','suffer from chronic disease','have diabetes','Egyption','muslim','farmer',' 2023/12/01');
insert into Prisoner (A_Id,P_id,F_name,L_name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('5','3','Abdelrahaman ','gamal',' 2010/11/01','suffer from aids','AIDS','Egyption','christain','plumber',' 2023/11/01');
insert into Prisoner (A_Id,P_id,F_name,L_name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('7','4','yehia','safwat',' 2014/11/28',' good health but should take his pills on time','depression','Egyption','muslim','Sheikh',' 2030/01/01');
insert into Prisoner (A_Id,P_id,F_name,L_name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('7','5','seif','wael',' 2015/11/01','should take his pills for withdrawal symptoms in time','drug addicit','Egyption','Jewish','drug dealer',' 2070/01/01');
insert into Prisoner (P_id,F_name,L_Name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('6','karim','Ahmed',' 2007/11/28','need chemo treatment','cancer','Egyption','Jewish','parking lot adminstrator',' 2100/01/01');
insert into Prisoner (P_id,F_name,L_Name,Arrival_Time,Health_Description,Health_Status,P_Nationality ,P_Religion,Past_Job,Departure_Time)
values ('7','Amr','el hamweet',' 2001/11/28','n/a','good','Egyption','muslim','shoplifter',' 2032/01/01');


insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('1','1','murder','10/10/2010','cairo','killed the victum with knife','1');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('2','2','sexual harasment','10/12/2002','mansoura','rapped the victum in metro','2');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('3','3','shoplifting','12/11/2020','cairo','stole from supplement store ','4');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('4','4','theft','11/10/2004','cairo','stole an atm machine','2');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('5','5','theft','11/02/2009','cairo','stole a car','2');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('6','6','theft','12/12/2012','salam city','stole microbus','2');
insert into Crime (Pr_Id,Crime_Code,Crime_Name,Crime_Time,Crime_Location,Crime_Description,Crime_Degree)
values ('7','7','murder','11/28/2022','cairo','killed the prisdent','1');


insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('7','1','small',' 2020/11/12',' 2020/11/19','sexual harasment inside the cell ');
insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('6','2','medium','2011/11/11',' 2011/11/15','hit other prisoner');
insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('5','3','large',' 2009/09/09',' 2009/09/12','hide sharp tools');
insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('4','4','small',' 2015/12/15','2015/12/20','sell cigarates inside the prison');
insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('3','5','medium',' 2009/11/16','2009/11/22','trying to escape ');
insert into Remand (Pr_Id,Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('2','6','large',' 2001/01/01',' 2001/01/10','attacked the jailor');
insert into Remand (Remand_No,Remand_Size,Remand_Start_Time,Remand_End_Time,Remand_Reason)
values ('7','small',' 2005/05/05',' 2005/05/12','blackmailing people in the prison');


insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('1','Food','10 ',' 2003/02/02',' 2004/02/02');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('2','water','1','2022/02/02','2023/02/02');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('3','medicine','200',' 2001/11/28',' 2005/11/28');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('4','Food','500',' 2000/05/02',' 2001/05/02');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('5','fist aid kit','150',' 2010/06/02','2012/06/02');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('6','Food','5',' 2000/09/01',' 2001/10/01');
insert into Supplies (Supplie_Id,Supplie_Type,Supplie_Price,Recieving_Time,Date_of_Expire)
values ('7','water','100',' 1990/04/01',' 1991/04/01');


insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('1','builiding A','12','14 ');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('2','building B','14','16');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('3','building C','16','18');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('4','building D','18','20');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('5','between builiding A and B','20','23');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('6','Between buliding B and C','12','6');
insert into Prison_Gate (Gate_Id,Gate_Location,Gate_OpeningTime,Gate_ClosingTime)
values ('7','between builiding C and D','6','12');


insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('1','prisoners transportation vehicle','12','22');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('2','prisoners transportation vehicle','16','23');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('3','prisoners transportation vehicle','6','1');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('4','prisoners transportation vehicle','17','15');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('5','prisoners transportation vehicle','0','20');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('6','prisoners transportation vehicle','1','22');
insert into Trasportation  (Transportation_id,Car_Type,Car_Arriving,Car_Departure)
values ('7','prisoners transportation vehicle','19','16');



insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('1','spoon','food equipment','spoon for eating with','1');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('2','fork','food equipment','fork for eating with','1');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('3','gun','jalors equipment','weapon ','5000');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('4','broom','cleaning equipment','a broom for cleaning the floors ','20');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('5','dish','food equipment','dish for eating on','2');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('6','cup','food hall equipment','cup for drinking water','5');
insert into Equipment  (Equipment_Id,Equipment_Name,Equipment_Type,Equipment_Description,Equipment_Price)
values ('7','towel','bathroom equipment','a towel for using after taking a shower','10');


insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('100','builiding A floor 1','12','0','controls lighing and display what the cameras see and closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('200','builiding A floor 2','0','12','controls lighing and display what the cameras see and closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('300','builiding B floor 1','12','0','controls lighing and display what the cameras see and control the closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('400','builiding B floor 2','0','12','controls lighing and display what the cameras see and control the closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('500','builiding C floor 1','12','0','controls lighing and display what the cameras see and control the closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('600','builiding C floor 2','0','12','controls lighing and display what the cameras see and control the closing and the opening of the cells and prison gates');
insert into Control_Room   (Room_Number,CR_Location,Work_Start_Time,Work_End_Time,Control_Panel)
values ('700','builiding D floor 1','12','23','controls lighing and display what the cameras see and control the closing and the opening of the cells and prison gates');



insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('100','1','2','building A','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('200','2','2','building A','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('300','3','2','building B','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('400','4','4','building B','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('500','5','4','building C','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('600','6','5','building C','12','22');
insert into Cell (Room_No,Cell_Number,Cell_Capacity,Cell_Location,Cell_Opening_Time,Cell_Closing_Time)
values ('700','7','3','building D','12','22');



insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('1','Building A floor 1','50','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('2','Building A floor 2','45','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('3','Building B floor 1','33','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('4','Building B floor 2','25','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('5','Building C floor 1','55','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('6','Building D floor 1','60','12','23');
insert into Hall (Hall_Number,Hall_Location,Capacity,Starting_Time,Ending_Time) 
values ('7','Building D floor 2','48','12','23');


insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('1','1','football','building A football yard','14','16');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('2','2','football','building A football yard','16','18');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('3','3','basketball','building B basketball yard','13','15');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('4','4','basketball','building B basketball yard','16','18');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('5','5','bakery','builiding B','10','13');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('6','6','farming ','builiding c','14','17');
insert into Activity (Hall_num,Activity_Id,Activity_Name,Activity_Location,Activity_StartingTime,Activity_EndingTime)
values ('7','7','cleaning ','building d','14','17');



insert into Visitor  (Pr_id,V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('7','1','Ahmad','Mohamed','driver','M','Muslim',' 1999/12/12','married','1','adly mansour');
insert into Visitor  (Pr_id,V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('6','2','Ashraf','Ahmed','Student','M','Muslim',' 1999/11/11','single','2','taqa street');
insert into Visitor  (Pr_id,V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('5','3','nancy','sharaf','belly dancer','F','Muslim',' 2002/12/12','single','3','haram street');
insert into Visitor  (Pr_id,V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('4','4','basmala','mohamed','farmer','F','Muslim','2001/12/12','engaged','4','makram abeid street');
insert into Visitor  (V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('5','khaled ','abdelgaber','doctor','M','Muslim','1980/01/01','married','5','hassan el mamon street');
insert into Visitor  (Pr_id,V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('2','6','ahmed ','elsaka','actor','M','Muslim',' 1979/01/01','married','6','mohmed aly street');
insert into Visitor  (V_Id,F_Name,L_Name,V_Job,V_Gender,V_Religion,V_DOB,V_State,Zip_Code,Street_Name)
values ('7','fady','kerolos','security','M','christan',' 2001/01/01','single','7','el asher street');



insert into Staff (Super_Ssn,G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('1','7','1','samy','ayman','M','user1@example.com','01000000001','12/05/2002','el taqa street','1','jailor','1000');
insert into Staff (Super_Ssn,G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('2','6','2','barkat','mohamed','M','user2@example.com','01000000002','02/02/1990','el tahrir street','2','control room staff','2000');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('5','3','ramy','ahmed','M','user3@example.com','01000000002','01/01/1970','zahraa nasr city street','3','food hall staff','1500');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('4','4','mostafa','ashraf','M','user4@example.com','01000000002','01/01/1969','zahraa el madii street','4','shrief assistant','2500');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('3','5','amr','ahmed','M','user5@example.com','01000000002','01/01/1965','90th south street','5','shrief','5000');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('2','6','wael ','ghonem','M','user6@example.com','01000000001','01/01/1987','el demerdash street','6','cleaning staff','1000');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('1','7','wael','kafory','M','user7@example.com','01000000001','01/02/1963','el dokii street','7','jailor','1000');
insert into Staff (G_Id,Staff_Id,F_Name,L_Name,Gender,E_Mail,Phone_No,S_DOB,Street_Name,Zip_Code,Job_Description,Salary)
values ('7','20','wael','mamdoh','M','user8@example.com','01000000001','01/02/1969','el markeb street','8','jailor manger','1800');


insert into food(Food_type,F_Id)
values ('Bread','1');
insert into food(Food_type,F_Id)
values ('Meat','2');
insert into food(Food_type,F_Id)
values ('Chicken','3');
insert into food(Food_type,F_Id)
values ('Potato','4');
insert into food(Food_type,F_Id)
values ('Rice','5');
insert into food(Food_type,F_Id)
values ('Eggs','6');
insert into food(Food_type,F_Id)
values ('Pasta','7');


insert into visit (V_Id,Visit_Item)
values ('1','t-shirt');
insert into visit (V_Id,Visit_Item)
values ('2','pants');
insert into visit (V_Id,Visit_Item)
values ('3','hoddie');
insert into visit (V_Id,Visit_Item)
values ('4','jaket');
insert into visit (V_Id,Visit_Item)
values ('5','chiken meal');
insert into visit (V_Id,Visit_Item)
values ('6','cheese cake');
insert into visit (V_Id,Visit_Item)
values ('7','om ali');


insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('10','7','1');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('25','6','2');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('20','5','3');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('30','4','4');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('11','3','5');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('19','2','6');
insert into Transport_by(Transportation_cost,pr_id,T_id)
values ('33','1','7');


insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('1','0','5');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('2','0','5');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('3','5','10');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('4','5','10');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('5','12','18');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('6','17','22');
insert into Guard(Guard_Id,Shift_start,Shift_end)   
values ('7','22','1');


insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to eat with','1','1');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to eat with','2','2');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to secure the gate','3','7');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to clean with','4','6');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to eat on','5','4');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to drink using it','6','5');
insert into Utilize(reason_of_usage,E_Id,S_ID)
values ('to use after bath','7','3');


insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('1','7','1','12');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('2','6','0','12');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('3','5','0','12');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('4','4','12','0');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('5','3','12','0');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('6','2','12','0');
insert into Supervise(Cell_NO,S_ID,s_starttime,s_endtime)
values ('7','1','0','12');



insert into staff_Phone(Stph_Id,Phone_Number)
values ('1','01000000003');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('2','01000000004');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('3','01000000005');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('4','01000000006');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('5','01000000007');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('6','01000000008');
insert into staff_Phone(Stph_Id,Phone_Number)
values ('7','01000000009');


insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('1','7','0','12');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('2','6','0','12');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('3','5','15','22');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('4','4','0','7');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('5','3','4','9');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('6','2','9','0');
insert into Manage(S_ID,R_no,M_starttime,M_endtime)
values ('7','1','0','20');



insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('1','7','to drink');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('2','6','to eat');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('3','5','for emergency');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('4','4','to eat');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('5','3','for disease healing');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('6','2','to drink');
insert into Require(St_Id,Sup_Id,Reason_of_requirment)
values ('7','1','to eat');


/* Query */


select avg (salary) as 'average salary' ,F_name as 'first name ',L_Name as 'last name', Job_Description as 'job describtion' 
from Staff
group by L_name ,F_Name,Job_Description
having F_name ='wael' 
and avg (salary)>500;



select F_name,L_name,P_Id
from Prisoner
where Past_Job='Programmer' 
or Departure_Time between 2023/01/01 and 2023/12/31 ;




select staff_id ,F_Name+' '+L_Name as'Employee Name' ,m.M_starttime as 'shift start time',m.M_endtime as 'shift end time',Remand_No as 'Remand Number'
from Staff , Remand , Manage m
where m.S_ID=Staff_Id and Remand_No=R_no and m.M_starttime in (select s.M_starttime
from Manage s
where s.M_starttime=m.M_starttime
and S_ID  != Staff_Id) 
and m.M_endtime in (select s.M_endtime
from Manage s
where s.M_endtime=m.M_endtime
and S_ID  != Staff_Id)
and M_endtime=m.M_endtime and m.M_starttime=M_starttime and S_ID=Staff_Id;




select Activity_id , Activity_Name,Activity_StartingTime,Activity_EndingTime,Hall_Location
from Activity join Hall
on Hall_num=Hall_number;



select v.F_name +' '+v.L_name as 'visitor name ',p.F_name +' '+p.L_name as 'prisoner name '
from Visitor v right outer join Prisoner p 
on P_Id in (select Pr_Id
from Visitor)
and P_Id=Pr_Id;



select  distinct Activity_Name as 'Activity',F_Name+' '+L_Name as 'Prisoner name',Activity_Location as 'the location',P_id as'Prisoner ID'
from  Prisoner left outer join Activity 
on A_Id=Activity_id;



select  Staff_Id as 'The ID of the orderer',F_Name+' '+L_Name as 'The Name of The orderer',Supplie_Id as 'Supplie ID ',Supplie_Type as 'Supplie name',Reason_of_requirment as 'The Reason of The order',Supplie_Price as 'Supplie Price',Date_of_Expire as 'The Expiry Date of The Supplie'
from Supplies , Staff full outer join Require  
on Staff_Id=St_Id  
where Supplie_Id=Sup_Id ;



select s.F_Name +' '+s.L_name as 'employee name ',s.Job_Description as 'employee job title',m.F_Name+' ' +m.L_Name as 'Manager name',m.Job_Description as'manger job title'
from Staff s join Staff m
on s.Super_Ssn=m.Staff_Id+1;



select F_Name+' '+L_Name as 'employee name',Room_Number as 'the supervised control room number',Work_Start_Time as 'the start of shift',Work_End_Time as 'the end of shift '
from Staff , Supervise,Cell,Control_Room   
where Staff_Id= s_id and Cell_Number =Cell_NO and Room_No=Room_Number;



select Staff_Id as 'Staff ID ',F_Name+' ' +L_Name as 'The Employee name' ,Salary as 'The Employee Salary '
from Staff 
where salary > all (select avg(Salary)
from Staff 
);


select Cell_Number as 'Cell Number',Cell_Location  as 'Cell location',Cell_Capacity
from Cell 
where Cell_Capacity > all (select min(Cell_Capacity)
from Cell );




select F_Name+' '+L_Name as 'Employee Name' ,Staff_Id as 'Employee ID'
from Staff
where G_Id in (select G_Id
from Staff
where Staff_Id=1)
and F_Name in (select F_Name
from Staff
where Staff_Id=7);


select F_Name+' '+L_Name as 'Prisoner Name' ,P_Id as 'Prisoner ID'
from Prisoner 
where not exists (select *
from Remand
where P_Id=Pr_Id);









SELECT S_DOB, Street_Name
FROM Staff
WHERE F_Name='samy' AND L_Name='ayman';

SELECT SUM (Salary) AS 'SUM SALARY', AVG (Salary) AS 'AVG SALARY', MIN (Salary) AS 'MIN SALARY', MAX (Salary)AS 'MAX SALARY'
FROM Staff WHERE Staff_Id  BETWEEN '1' AND '7';

SELECT F_Name+' '+ L_Name as 'Employee Name', Phone_Number as 'Phone number'
FROM Staff JOIN staff_Phone
ON Staff_Id = Stph_Id;

SELECT  S_ID as 'Staff ID',Cell_Number
FROM Cell LEFT OUTER JOIN Supervise
ON Cell_Number in (select Cell_NO
from Supervise)
and Cell_NO=Cell_Number;

SELECT V.F_Name+' '+ V.L_Name as 'Vistor Name', Pr_Id as 'Prisoner ID'
FROM Prisoner LEFT OUTER JOIN Visitor V
ON Prisoner.P_Id = V.V_Id;


SELECT P_Id AS 'Prisoner ID', e.F_Name AS 'Prisoner FIRST Name', e.L_Name AS 'Prisoner LAST Name',Remand_No
FROM Prisoner e full outer join  Remand
on P_Id = Pr_Id;

SELECT F_Name+' '+ L_Name as 'Employee Name', Salary
FROM Staff
WHERE Salary > ALL (SELECT Salary
FROM Staff
WHERE Staff_Id = '3');

SELECT DISTINCT Gate_ID
FROM Prison_Gate
WHERE Gate_Id IN(SELECT Gate_Id
FROM Prison_Gate, Staff
WHERE Prison_Gate.Gate_Id = Staff.Staff_Id 
AND F_Name = 'amr');

SELECT F_Name+' '+ L_Name as 'Staff Name', Staff_Id 
FROM Staff
WHERE EXISTS (SELECT *
FROM Equipment
WHERE Equipment_id = Staff_Id);

SELECT Car_Arriving , Car_Departure , Car_Type , P_Id as'Prisoner ID', P_Nationality , F_Name+' '+ L_Name as 'Prisoner Name'
FROM Trasportation JOIN Prisoner
ON Trasportation.Transportation_id = Prisoner.P_Id
WHERE Transportation_id BETWEEN '1' AND '7';

SELECT P_Id as 'Prisoner ID', F_Name+''+L_Name as 'Prisoner Name',Crime_Name as 'crime name',Remand_No as 'Remand number'
FROM Crime,Prisoner , Remand
where  P_Id=Remand.Pr_Id and P_Id=Crime.Pr_Id;







SELECT P_Id, F_Name, L_Name, P_Religion  
From Prisoner
WHERE P_Id between '1' and '7';

SELECT Cell_Capacity as 'Cell Capacity'
FROM Cell
WHERE  Cell_Number  between 1 and 7;

SELECT MAX (Equipment_Price)as 'Max price ',AVG (Equipment_Price) as 'Avereage cost ', MIN (Equipment_Price)as 'Min cost',  SUM (Equipment_Price) as 'Total price'
FROM Equipment ;


SELECT P_Id, F_Name, L_Name, Crime_Name, Crime_Degree
FROM Prisoner JOIN Crime
ON Prisoner.P_Id = Crime.Crime_Code;

select p.P_Id as 'Prisoner ID ', p.F_Name+' '+p.L_Name as 'Prisoner Name ' , Remand_No as 'Remand Cell Number'
from Prisoner p left outer join Remand r
on p.P_Id=r.Pr_Id;


select Staff_Id,F_Name+' '+L_Name as 'Employee Who ordered The Equipment Name',Equipment_Name as 'Equipment Name'
from Staff,Utilize,Equipment
where Staff_Id =S_ID and E_Id in(select Equipment_id
from Equipment )
and Equipment_id=E_Id;

SELECT p.F_Name+ ' ' + p.L_Name as 'Prisoner Name', v.F_Name+' '+ v.L_Name as 'Visitor Name'
FROM Prisoner p left outer join Visitor v
on EXISTS (SELECT *
FROM Visitor)
and P_Id = Pr_Id;


select Equipment_Name as 'Name of The equipment',Equipment_id as 'Equipment ID',Equipment_Price as 'Equipment Price '
from Equipment 
where Equipment_Price > all (select min(Equipment_Price)
from Equipment 
);


SELECT Phone_No ,Staff_Id
FROM  Staff 
WHERE Staff_Id BETWEEN '5' AND '7';


select  count (A_Id) as' prisoner name'
from Activity join Prisoner
on A_Id=Activity_id
and Activity_Name='cleaning';

SELECT F_Name, L_Name ,Pr_Id , Remand_No, Remand_Start_Time, Remand_End_Time
FROM Prisoner JOIN Remand
ON P_Id = Pr_Id;


select  Visitor.F_Name,V_Id,Prisoner.F_Name,P_Id
from Visitor right outer join Prisoner
ON Pr_Id = P_Id;

SELECT F_Name, L_Name
FROM Prisoner
WHERE NOT EXISTS (SELECT *
FROM Remand
WHERE P_Id = Pr_Id);


select Equipment_id , reason_of_usage
from Equipment join Utilize
on E_Id=Equipment_id;




SELECT F_Name, L_Name
FROM Prisoner
WHERE P_Id = '5';

SELECT  MIN (Supplie_Price) as 'min supplie price', AVG (Supplie_Price) as 'average supplie price',MAX (Supplie_Price) as 'max supplie price' 
FROM Supplies ;


SELECT S_ID
FROM Supervise ;


select S_ID as 'Staff ID', Cell_Number as 'Cell Number'
from Supervise, Cell 
where Cell_Number= Cell_NO AND Cell_NO IN (select (Cell_Number)
from Cell 
);


SELECT F_Name, L_Name, Remand_End_Time
FROM Remand JOIN Prisoner
ON Pr_Id = P_Id;


select Equipment_Name
from Equipment
where Equipment_id between 1 and 5;


select Remand_No as 'Remand number',S_ID as 'Staff ID'
from Manage join Remand
on R_no=Remand_No;



SELECT  S_ID as 'Staff ID',Cell_Number
FROM Cell LEFT OUTER JOIN Supervise
ON Cell_Number in (select Cell_NO
from Supervise)
and Cell_NO=Cell_Number;



select F_Name+' '+L_Name as'Prisoner Name',Transportation_cost as 'Transportaion Cost',Car_Arriving as 'Arriving time' ,Car_Departure as 'Departure time'
from Prisoner,Transport_by,Trasportation
where Transportation_cost=25 and pr_id=P_Id and Transportation_id=T_id;


select avg(salary) as 'Average Salary',F_Name+' '+L_Name as'Employee Name',Staff_Id
from Staff
where Job_Description='jailor'
group by F_Name ,L_Name,Staff_Id;


select F_Name+' '+L_Name as'Employee Name',Phone_No as'Employee phone number'
from  Staff full outer join staff_Phone 
on Stph_Id=Staff_Id;

select  F_Name+' '+L_Name as'Employee Name',Salary as 'Employee Salary'
from Staff 
where Staff_Id< all (select avg(Staff_id)
from Staff);

select F_Name+' '+L_Name as 'prisoner name ' ,P_Id as 'prisoner id ', Remand_No as 'remand cell number'
from Prisoner  left outer join Remand 
on P_Id=Pr_Id; 


select staff_id ,F_Name+' '+L_Name as'Employee Name' ,m.s_starttime as 'shift start time',m.s_endtime as 'shift end time'
from Staff join Supervise m
on m.S_ID=Staff_Id and m.s_starttime in (select s.s_starttime
from supervise s
where s.s_starttime=m.s_starttime
and S_ID  != Staff_Id) 
and m.s_endtime in (select s.s_endtime
from supervise s
where s.s_endtime=m.s_endtime
and S_ID  != Staff_Id)
where s_endtime=m.s_endtime and m.s_starttime=s_starttime and S_ID=Staff_Id;

SELECT F_Name, L_Name
FROM Prisoner
WHERE NOT EXISTS (SELECT *
FROM Remand
WHERE P_Id = Pr_Id)
and Past_Job='Programmer';
