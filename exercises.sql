------------------------ CHECK DATA --------------------------------

SELECT * FROM cd.bookings
LIMIT 5;

SELECT * FROM cd.facilities
LIMIT 5;

SELECT * FROM cd.members
LIMIT 5;

--------------------------------------------------------------------

' How can you retrieve all the information from the cd.facilities table? '

SELECT * FROM cd.facilities;

--------------------------------------------------------------------

' You want to print out a list of all of the facilities and their cost to members. 
How would you retrieve a list of only facility names and costs? '

SELECT name, membercost FROM cd.facilities;

--------------------------------------------------------------------

' How can you produce a list of facilities that charge a fee to members? '

SELECT * FROM cd.facilities;

SELECT name, membercost FROM cd.facilities
WHERE membercost > 0;

----------------------------------------------------------------------

'How can you produce a list of facilities that charge a fee to members, 
and that fee is less than 1/50th of the monthly maintenance cost? 
Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.'


SELECT * FROM cd.facilities;

SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 
AND membercost < (monthlymaintenance/50);

------------------------------------------------------------------------

' How can you produce a list of all facilities with the word 'Tennis' in their name? '

SELECT * FROM cd.facilities;

SELECT name FROM cd.facilities
WHERE name LIKE '%Tennis%';


-----------------------------------------------------------------------

'How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.'

SELECT * FROM cd.facilities;

SELECT * FROM cd.facilities
WHERE facid IN (1, 5);

----------------------------------------------------------------------

'How can you produce a list of members who joined after the start of September 2012? 
Return the memid, surname, firstname, and joindate of the members in question.'


SELECT * FROM cd.members;

SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE EXTRACT(MONTH FROM joindate) = 9;


------------------------------------------------------------------------

'How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.'

SELECT * FROM cd.members;

SELECT DISTINCT surname
FROM cd.members
ORDER BY surname
LIMIT 10;

SELECT * FROM cd.members
WHERE surname = 'Bader';


-------------------------------------------------------------------------------------


'Youd like to get the signup date of your last member. How can you retrieve this information?'

SELECT * FROM cd.members;

SELECT * FROM cd.members
ORDER BY joindate DESC
LIMIT 1;

select max(joindate) as latest from cd.members;

----------------------------------------------------------------------------------------


'Produce a count of the number of facilities that have a cost to guests of 10 or more.'

SELECT * FROM cd.facilities;

SELECT COUNT(*) FROM cd.facilities
WHERE guestcost >= 10;


------------------------------------------------------------------------------------------


'Produce a list of the total number of slots booked per facility in the month of September 2012. 
Produce an output table consisting of facility id and slots, sorted by the number of slots.'

SELECT * FROM cd.bookings;


SELECT facid, SUM(slots) AS numer_of_slots FROM cd.bookings
WHERE EXTRACT(MONTH FROM starttime) = 9
GROUP BY facid
ORDER BY SUM(slots);


------------------------------------------------------------------------------------------------


'Produce a list of facilities with more than 1000 slots booked. 
Produce an output table consisting of facility id and total slots, sorted by facility id.'

SELECT * FROM cd.bookings;

SELECT facid, SUM(slots) AS number_of_slots
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY number_of_slots
;

------------------------------------------------------------------------------------------------------

'How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
Return a list of start time and facility name pairings, ordered by the time.'

SELECT * FROM cd.bookings;
SELECT * FROM cd.facilities;

SELECT starttime, facid
FROM cd.bookings
WHERE EXTRACT(MONTH FROM starttime) = 9 AND EXTRACT(DAY FROM starttime) = 21
ORDER BY starttime;

SELECT cd.bookings.starttime AS start_time, cd.facilities.name AS facilitie_name
FROM cd.bookings 
JOIN cd.facilities ON cd.facilities.facid = cd.bookings.facid
WHERE EXTRACT(MONTH FROM cd.bookings.starttime) = 9 AND EXTRACT(DAY FROM cd.bookings.starttime) = 21
ORDER BY start_time;

SELECT bkn.starttime AS start_time, fac.name AS facilitie_name
FROM cd.bookings AS bkn
JOIN cd.facilities AS fac ON fac.facid = bkn.facid
WHERE EXTRACT(MONTH FROM bkn.starttime) = 9 AND EXTRACT(DAY FROM bkn.starttime) = 21
ORDER BY start_time;


------------------------------------------------------------------------------------------------------

'How can you produce a list of the start times for bookings by members named 'David Farrell'?'


SELECT * FROM cd.bookings;
SELECT * FROM cd.members;


SELECT cd.members.firstname || ' ' || cd.members.surname AS full_name, cd.bookings.starttime AS start_time
FROM cd.bookings
JOIN cd.members ON cd.bookings.memid = cd.members.memid
WHERE cd.bookings.memid = (SELECT memid FROM cd.members
WHERE firstname || ' ' || surname = 'David Farrell')
ORDER BY start_time;
