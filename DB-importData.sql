USE DDDB;

INSERT INTO DDDB.Person(pid, last, first)
SELECT pid, last, first
FROM digitaldemocracy.Person;

INSERT INTO DDDB.Legislator(description)
SELECT description
FROM digitaldemocracy.Person;

INSERT INTO DDDB.Legislator(pid)
SELECT pid
FROM digitaldemocracy.Legislator;

INSERT INTO DDDB.Term(pid, year, district, house, party, start, end)
SELECT pid, year, district, house, party, start, end
FROM digitaldemocracy.Term;

INSERT INTO DDDB.Committee(cid, house, name)
SELECT cid, house, name
FROM digitaldemocracy.Committee;

INSERT INTO DDDB.servesOn(pid, year, district, house, cid)
SELECT pid, year, district, house, cid
FROM digitaldemocracy.servesOn;

INSERT INTO DDDB.Bill(bid, type, number, state, status, house, session)
SELECT bid, type, number, state, status, house, session
FROM digitaldemocracy.Bill;

INSERT INTO DDDB.Hearing(hid, date, cid)
SELECT hid, date, cid
FROM digitaldemocracy.Hearing;

INSERT INTO DDDB.JobSnapshot(pid, hid, role, employer, client)
SELECT pid, hid, role, employer, client
FROM digitaldemocracy.JobSnapshot;

INSERT INTO DDDB.Action(bid, date, text)
SELECT bid, date, text
FROM digitaldemocracy.Action;

INSERT INTO DDDB.Video(vid, youtubeId, hid, position, startOffset, duration)
SELECT vid, youtubeId, hid, position, startOffset, duration
FROM digitaldemocracy.Video;

INSERT INTO DDDB.Video_ttml(vid, ttml)
SELECT vid, ttml
FROM digitaldemocracy.Video_ttml;

SELECT 'BillDiscussion' AS '';

INSERT INTO DDDB.BillDiscussion(bid, hid, startVideo, startTime, endVideo, endTime, numVideos)
SELECT bid, hid, startVideo, startTime, endVideo, endTime, numVideos
FROM digitaldemocracy.BillDiscussion;

INSERT INTO DDDB.Motion(mid, bid, date, text)
SELECT mid, bid, date, text
FROM digitaldemocracy.Motion;

INSERT INTO DDDB.votesOn(pid, mid, vote)
SELECT pid, mid, vote
FROM digitaldemocracy.votesOn;

INSERT INTO DDDB.BillVersion(vid, bid, date, state, subject, appropriation, substantive_changes, title, digest, text)
SELECT vid, bid, date, state, subject, appropriation, substantive_changes, title, digest, text
FROM digitaldemocracy.BillVersion;

INSERT INTO DDDB.authors(pid, bid, vid, contribution)
SELECT pid, bid, vid, contribution
FROM digitaldemocracy.authors;

INSERT INTO DDDB.attends(pid, hid)
SELECT pid, hid
FROM digitaldemocracy.attends;

INSERT INTO DDDB.Utterance(uid, vid, pid, time, endTime, text, current, finalized, type, alignment)
SELECT uid, vid, pid, time, endTime, text, current, finalized, type, alignment
FROM digitaldemocracy.Utterance;

CREATE OR REPLACE VIEW currentUtterance AS SELECT uid, vid, pid, time, endTime, text, type, alignment FROM Utterance WHERE current = TRUE AND finalized = TRUE ORDER BY time DESC;

INSERT INTO DDDB.tag(tid, tag)
SELECT tid, tag
FROM digitaldemocracy.tag;

INSERT INTO DDDB.Mention(uid, pid)
SELECT uid, pid
FROM digitaldemocracy.Mention;

INSERT INTO DDDB.TT_Editor(id, username, password, created, active, role)
SELECT id, username, password, created, active, role
FROM digitaldemocracy.TT_Editor;

INSERT INTO DDDB.TT_Task(tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed)
SELECT tid, did, editor_id, name, vid, startTime, endTime, created, assigned, completed
FROM digitaldemocracy.TT_Task;

INSERT INTO DDDB.TT_TaskCompletion(tcid, tid, completion)
SELECT tcid, tid, completion
FROM digitaldemocracy.TT_TaskCompletion;