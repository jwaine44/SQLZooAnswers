/*
TABLES

stops(id, name)
route(num, company, pos, stop)
*/

-- 1. How many stops are in the database.
SELECT COUNT(id) FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT stops.id, stops.name FROM stops LEFT JOIN route ON stops.id = route.stop WHERE route.num = '4' AND route.company = 'LRT';

-- 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2;

-- 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149;

-- 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops stopa ON (a.stop=stopa.id)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Fairmilehead' AND stopb.name = 'Tollcross';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT(a.company), a.num FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.id = 115 AND stopb.id = 137;

SELECT DISTINCT(a.company), a.num FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.id = 'Haymarket' AND stopb.name = 'Leith';

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT(a.company) FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.id = 'Craiglockhart' AND stopb.name = 'Tollcross';

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT DISTINCT(stops2.name), route2.company, route2.num FROM stops stops1, stops stops2, route route1, route route2 
WHERE stops1.name = 'Craiglockhart' 
AND stops1.id = route1.stop 
AND route1.company = route2.company 
AND route1.num = route2.num 
AND route2.stop = stops2.id;

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.
SELECT route1.num, route1.company, stop1.name, route4.num, route4.company FROM route route1
JOIN route route2 ON route1.num = route2.num AND route1.company = route2.company
JOIN stops stop1 ON route2.stop = stop1.id
JOIN route route3 ON stop1.id = route3.stop
JOIN route route4 ON route3.num = route4.num AND route3.company = route4.company
WHERE route1.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
AND route4.stop = (SELECT id FROM stops WHERE name = 'Lochend')
ORDER BY route1.num, stop1.name, route4.num;