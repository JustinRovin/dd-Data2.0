USE digitaldemocracy;

INSERT INTO tester.Person(pid, last, first)
SELECT pid, last, first
FROM digitaldemocracy.Person;

INSERT INTO tester.Legislator
SELECT Legislator.pid, Person.description
FROM digitaldemocracy.Person JOIN digitaldemocracy.Legislator
WHERE Legislator.pid = Person.pid;

INSERT INTO tester.Term(pid, year, district, house, party, start, end)
SELECT pid, year, district, house, party, start, end
FROM digitaldemocracy.Term;

INSERT INTO tester.Committee(cid, house, name)
SELECT cid, house, name
FROM digitaldemocracy.Committee;

INSERT INTO tester.servesOn(pid, year, district, house, cid)
SELECT pid, year, district, house, cid
FROM digitaldemocracy.servesOn;

INSERT INTO tester.Bill(bid, type, number, state, status, house, session)
SELECT bid, type, number, state, status, house, session
FROM digitaldemocracy.Bill;

INSERT INTO tester.Hearing(hid, date, cid)
SELECT hid, date, cid
FROM digitaldemocracy.Hearing;

INSERT INTO tester.JobSnapshot(pid, hid, role, employer, client)
SELECT pid, hid, role, employer, client
FROM digitaldemocracy.JobSnapshot;

INSERT INTO tester.Action(bid, date, text)
SELECT bid, date, text
FROM digitaldemocracy.Action;

INSERT INTO tester.Video(vid, youtubeId, hid, position, startOffset, duration)
SELECT vid, youtubeId, hid, position, startOffset, duration
FROM digitaldemocracy.Video;

INSERT INTO tester.Video_ttml(vid, ttml)
SELECT vid, ttml
FROM digitaldemocracy.Video_ttml;

SELECT 'BillDiscussion' AS '';

INSERT INTO tester.BillDiscussion(bid, hid, startVideo, startTime, endVideo, endTime, numVideos)
SELECT bid, hid, startVideo, startTime, endVideo, endTime, numVideos
FROM digitaldemocracy.BillDiscussion;

INSERT INTO tester.Motion(mid, bid, date, text)
SELECT mid, bid, date, text
FROM digitaldemocracy.Motion;

INSERT INTO tester.votesOn(pid, mid, vote)
SELECT pid, mid, vote
FROM digitaldemocracy.votesOn;

INSERT INTO tester.BillVersion(vid, bid, date, state, subject, appropriation, substantive_changes, title, digest, text)
SELECT vid, bid, date, state, subject, appropriation, substantive_changes, title, digest, text
FROM digitaldemocracy.BillVersion;

INSERT INTO tester.authors(pid, bid, vid, contribution)
SELECT pid, bid, vid, contribution
FROM digitaldemocracy.authors;

INSERT INTO tester.attends(pid, hid)
SELECT pid, hid
FROM digitaldemocracy.attends;

SELECT 'Utterance Issues' AS '';

INSERT INTO tester.Utterance(uid, vid, pid, time, endTime, text, type, alignment)
SELECT uid, vid, pid, time, endTime, text, type, alignment 
FROM digitaldemocracy.currentUtterance
WHERE NOT EXISTS (
	SELECT 1 FROM tester.Utterance AS e
	WHERE e.vid = vid 
	AND e.pid = pid 
	AND e.time = time);

INSERT INTO tester.tag(tid, tag)
SELECT uid, tag
FROM digitaldemocracy.tag
ON DUPLICATE KEY UPDATE tid = tid + 2;

INSERT INTO tester.Mention(uid, pid)
SELECT uid, pid
FROM digitaldemocracy.Mention;

INSERT INTO tester.TT_Editor(id, username, password, created, active, role)
SELECT id, username, password, created, active, role
FROM digitaldemocracy.TT_Editor;

-- empty
INSERT INTO tester.TT_Task(tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed)
SELECT tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed
FROM digitaldemocracy.TT_Task;

INSERT INTO tester.TT_TaskCompletion(tcid, tid, completion)
SELECT tcid, tid, completion
FROM digitaldemocracy.TT_TaskCompletion;

INSERT INTO tester.LobbyingFirm(filer_id, filer_naml, rpt_date, ls_beg_yr, ls_end_yr)
SELECT filer_id, filer_naml, rpt_date, ls_beg_yr, ls_end_yr
FROM digitaldemocracy.LOBBYING_FIRMS;

INSERT INTO tester.GeneralPublic(pid, hid, employer)
SELECT pid, hid, employer
FROM digitaldemocracy.JobSnapshot
WHERE role = 'General_public'
ON DUPLICATE KEY UPDATE pid = JobSnapshot.pid;


INSERT INTO tester.Analyst(pid, hid)
SELECT DISTINCT pid, hid
FROM digitaldemocracy.JobSnapshot
WHERE role = 'Legislative_analyst'
ON DUPLICATE KEY UPDATE pid = JobSnapshot.pid;

INSERT INTO tester.StateAgencyRep(pid, hid, employer)
SELECT DISTINCT pid, hid, employer
FROM digitaldemocracy.JobSnapshot
WHERE role = 'State_agency_rep'
ON DUPLICATE KEY UPDATE pid = JobSnapshot.pid;

-- No Legislative Staff Committee
-- No Legislative Staff Author

