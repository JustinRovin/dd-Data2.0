USE tester;

INSERT INTO tester.Person(pid, last, first)
SELECT pid, last, first
FROM digitaldemocracy.Person;

INSERT INTO tester.Legislator(description)
SELECT description
FROM digitaldemocracy.Person;

INSERT INTO tester.Legislator(pid)
SELECT pid
FROM digitaldemocracy.Legislator;

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

INSERT INTO tester.Utterance(uid, vid, pid, time, endTime, text, type, alignment)
SELECT uid, vid, pid, time, endTime, text, type, alignment 
FROM digitaldemocracy.currentUtterance;

INSERT INTO tester.tag(tid, tag)
SELECT uid, tag
FROM digitaldemocracy.tag;

INSERT INTO tester.Mention(uid, pid)
SELECT uid, pid
FROM digitaldemocracy.Mention;

INSERT INTO tester.TT_Editor(id, username, password, created, active, role)
SELECT id, username, password, created, active, role
FROM digitaldemocracy.TT_Editor;

INSERT INTO tester.TT_Task(tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed)
SELECT tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed
FROM digitaldemocracy.TT_Task;

INSERT INTO tester.TT_TaskCompletion(tcid, tid, completion)
SELECT tcid, tid, completion
FROM digitaldemocracy.TT_TaskCompletion;