select
     proposalClass.id
     , proposalClass.chinName as chinName
     , proposalClass.engName as engName
     , proposalClass.portName as portName


     classAddress.chinName  proposalClass.classRoom as chinClassVenue
     classAddress.portName  proposalClass.classRoom as portClassVenue
     venue.chinese

                ProposalClass_Venue pvenue on proposalClass2.id = pvenue.ProposalClass_id
                Venue venue on venue.id = pvenue.venues_id

              venue.portuguese

     , dbo.getDateStr(endEnrollmentDate, 1, 1)
     , dbo.getDateStr(endEnrollmentDate, 0 ,0)
     ,classSeqNum
     ,workflowStatus
     ,proposalClass.yearCourse_id as yearCourseId
     ,proposalClass.uniqueCode as classCode
     ,proposalClass.courseOutlineDocCode as outlineDmsId
     ,proposalClass.enrollmentProcess as enrollmentProcess   --REGISTRATION--0,ADMISSION--1,FINISH--2
from trainingtest.dbo.proposalClass as proposalClass
     left join trainingtest.dbo.classAddress as classAddress on proposalClass.classAddress_id = classAddress.id
     --left join trainingtest.dbo.ProposalClass_Venue pvenue on proposalClass.id = pvenue.ProposalClass_id
     --left join trainingtest.dbo.Venue venue on venue.id = pvenue.venues_id
group by
       proposalClass.id
     , proposalClass.chinName
     , proposalClass.engName
     , proposalClass.portName
     , proposalClass.startEnrollmentDate
     ,proposalClass.endEnrollmentDate
     , proposalClass.startDate
     ,proposalClass.endDate
     ,hours
     ,(hours-maxAbsence)/hours
     ,classSeqNum
     ,workflowStatus
     ,classAddress.chinName
     ,classAddress.portName
     ,proposalClass.classRoom
     ,proposalClass.yearCourse_id
     ,proposalClass.uniqueCode
     ,proposalClass.courseOutlineDocCode
     ,proposalClass.enrollmentProcess
