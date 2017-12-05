SELECT          YEAR(pc.startDate) AS year, yearCategory.chinName AS yearCategory, CONVERT(VARCHAR(50), c.id)
                            + ' ' + CASE WHEN c.chinName IS NULL OR
                            c.chinName = '' THEN c.portName ELSE c.chinName END AS courseName, stuff
                                ((SELECT          ', ' + CASE WHEN Category.chinName IS NULL OR
                                                                Category.chinName = '' THEN Category.portName ELSE Category.chinName END
                                    FROM              Course_Category LEFT JOIN
                                                                Category ON Category.id = Course_Category.categories_id
                                    WHERE          Course_Category.courses_id = c.id FOR XML PATH('')), 1, 2, '') AS courseCategory,
                            pc.classSeqNum + ' ' + pc.chinName AS className, pc.chinName AS className_CH,
                            pc.portName AS className_PT, pc.hours, tl.chinese AS language, o_m.nickname AS manager,
                            o_h.nickname AS helper, CONVERT(smalldatetime, pc.startDate) AS startDate, CONVERT(smalldatetime, pc.endDate)
                            AS endDate, stuff
                                ((SELECT          ', ' + Venue.chinese
                                    FROM              ProposalClass_Venue LEFT JOIN
                                                                Venue ON venues_id = Venue.id
                                    WHERE          ProposalClass_id = pc.id FOR XML PATH('')), 1, 2, '') AS locations, stuff
                                ((SELECT          ', ' + cooperators
                                    FROM              (SELECT          cooperator_id AS id, Cooperator.chinese AS cooperators
                                                                FROM               ProposalClass LEFT JOIN
                                                                                            Cooperator ON Cooperator.id = ProposalClass.cooperator_id
                                                                WHERE           ProposalClass.id = pc.id
                                                                UNION ALL
                                                                SELECT          cooperator2_id AS id, Cooperator.chinese AS cooperators
                                                                FROM              ProposalClass LEFT JOIN
                                                                                            Cooperator ON Cooperator.id = ProposalClass.cooperator2_id
                                                                WHERE          ProposalClass.id = pc.id
                                                                UNION ALL
                                                                SELECT          cooperator3_id AS id, Cooperator.chinese AS cooperators
                                                                FROM              ProposalClass LEFT JOIN
                                                                                            Cooperator ON Cooperator.id = ProposalClass.cooperator3_id
                                                                WHERE          ProposalClass.id = pc.id
                                                                UNION ALL
                                                                SELECT          cooperator4_id AS id, Cooperator.chinese AS cooperators
                                                                FROM              ProposalClass LEFT JOIN
                                                                                            Cooperator ON Cooperator.id = ProposalClass.cooperator4_id
                                                                WHERE          ProposalClass.id = pc.id) AS tmp
                                    ORDER BY   id FOR XML PATH('')), 1, 2, '') AS cooperators, a.student_id AS studentID,
                            CASE WHEN s.chinName IS NULL OR
                            s.chinName = '' THEN s.portName ELSE s.chinName END AS studentName, s.chinName AS studentName_CH,
                            s.portName AS studentName_PT, replace(replace(replace(s.idNumber, '/', ''), '(', ''), ')', '') AS idNumber,
                            CASE s.sex WHEN 'F' THEN '女' WHEN 'M' THEN '男' ELSE NULL END AS sex, e.chinese AS educationLevel, nl.chinese AS nativeLang,
                            CASE a.studentType WHEN 0 THEN '公職人員' ELSE '非公職人員' END AS studentType,
                            at.chinDesc AS admissionType, FLOOR(DATEDIFF(day, s.birthday, pc.startDate) / 365.242199) AS admissionAge,
                            CASE a.studentType WHEN 0 THEN ga_a.abbr + ' ' + ga_a.chinName ELSE a.subsidiaryOrgan END AS admissionEntity,
                             gd_a.chinName AS admissionGovDept, ap_a.chinDesc AS admissionAppointmentType,
                            gg_a.chinName AS admissionGovGrade, gp_a.chinDesc AS admissionGovPost,
                            gr_a.chinDesc AS admissionGovRank, jc_a.chinese AS admissionJobScope, FLOOR(DATEDIFF(day, s.birthday,
                            GETDATE()) / 365.242199) AS currentAge,
                            CASE s.studentType WHEN 0 THEN ga_s.abbr + ' ' + ga_s.chinName ELSE s.subsidiaryOrgan END AS currentEntity,
                            gd_a.chinName AS currentGovDept, ap_a.chinDesc AS currentAppointmentType, gg_s.chinName AS currentGovGrade,
                            gp_s.chinDesc AS currentGovPost, gr_s.chinDesc AS currentGovRank, jc_s.chinese AS currentJobScope,
                            CASE WHEN pcs.qualification = 0 THEN 1 ELSE 0 END AS isPass,
                            CASE WHEN pcs.complete = 1 THEN 1 ELSE 0 END AS hasCert,
                            CASE WHEN a.admissionStatus = 0 THEN 1 ELSE 0 END AS isAdmitted,
                            CASE WHEN pc.workflowStatus = 3 THEN '已取消' WHEN pcs.qualification = 0 AND
                            pcs.complete = 1 THEN '合格、獲証書' WHEN pcs.qualification = 0 AND (pcs.complete IS NULL OR
                            pcs.complete = 0)
                            THEN '合格' WHEN pcs.qualification = 1 THEN '不合格' WHEN pcs.qualification = 2 THEN '待補讀' WHEN pcs.complete
                             = 1 THEN '獲証書' WHEN CONVERT(date, getdate()) > pc.endDate AND
                            a.admissionStatus = 0 THEN '成績待定' WHEN CONVERT(date, getdate()) <= pc.endDate AND CONVERT(date,
                            getdate()) >= pc.startDate AND a.admissionStatus = 0 THEN '修讀中' WHEN CONVERT(date, getdate())
                            < pc.startDate AND a.admissionStatus = 0 THEN '已綠取' WHEN a.admissionStatus = 2 OR
                            (CONVERT(date, getdate()) >= pc.startDate AND a.admissionStatus = 1) THEN '不獲綠取' WHEN (CONVERT(date,
                            getdate()) < pc.startDate AND a.admissionStatus = 1) THEN '甄選中' ELSE NULL END AS studentStatus,
                            c.id AS courseID, pc.classSeqNum
FROM              dbo.ProposalClassAdmission AS a LEFT OUTER JOIN
                            dbo.Student AS s ON a.student_id = s.id LEFT OUTER JOIN
                            dbo.NativeLanguage AS nl ON nl.id = s.nativeLanguage_id LEFT OUTER JOIN
                            dbo.EduLevel AS e ON e.id = s.eduLevel_id LEFT OUTER JOIN
                            dbo.GovAgencyView AS ga_a ON ga_a.id = a.govAgency_id LEFT OUTER JOIN
                            dbo.GovAgencyView AS ga_s ON ga_s.id = s.govAgency_id LEFT OUTER JOIN
                            dbo.JobScope AS jc_a ON jc_a.id = a.jobScope_id LEFT OUTER JOIN
                            dbo.JobScope AS jc_s ON jc_s.id = s.jobScope_id LEFT OUTER JOIN
                            dbo.GovDepartmentView AS gd_a ON gd_a.id = a.govDepartment_id LEFT OUTER JOIN
                            dbo.GovDepartmentView AS gd_s ON gd_s.id = s.govDepartment_id LEFT OUTER JOIN
                            dbo.AppointmentView AS ap_a ON ap_a.id = a.appointment_id LEFT OUTER JOIN
                            dbo.AppointmentView AS ap_s ON ap_s.id = s.appointment_id LEFT OUTER JOIN
                            dbo.GovGrade AS gg_a ON gg_a.id = a.govGrade_id LEFT OUTER JOIN
                            dbo.GovGrade AS gg_s ON gg_s.id = s.govGrade_id LEFT OUTER JOIN
                            dbo.GovPostView AS gp_a ON gp_a.id = a.govPost_id LEFT OUTER JOIN
                            dbo.GovPostView AS gp_s ON gp_s.id = s.govPost_id LEFT OUTER JOIN
                            dbo.GovRankView AS gr_a ON gr_a.id = a.govRank_id LEFT OUTER JOIN
                            dbo.GovRankView AS gr_s ON gr_s.id = s.govRank_id LEFT OUTER JOIN
                            dbo.AdmissionTypeView AS at ON at.code = a.admissionType_code LEFT OUTER JOIN
                            dbo.ProposalClass AS pc ON pc.id = a.proposalClass_id LEFT OUTER JOIN
                            dbo.ProposalClassScore AS pcs ON pcs.student_id = a.student_id AND
                            a.proposalclass_id = pcs.proposalclass_id LEFT OUTER JOIN
                            dbo.TeachingLanguage AS tl ON tl.id = pc.teachingLanguage_id LEFT OUTER JOIN
                            dbo.Course AS c ON c.id = pc.fromCourse_id LEFT OUTER JOIN
                            dbo.YearCourse AS yc ON yc.id = pc.yearCourse_id LEFT OUTER JOIN
                            dbo.YearCategory ON yearCategory.id = yc.sourceCourse_id LEFT OUTER JOIN
                            dbo.Operator o_m ON o_m.id = pc.manager_id LEFT OUTER JOIN
                            dbo.Operator o_h ON o_h.id = pc.helper_id
WHERE          pc.workflowStatus IN (1, 2) --AND a.admissionStatus = 0
 
