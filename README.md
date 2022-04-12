# UIUC-Course-Grade-Visualization

## Purpose

The purpose of this app is for students who are considering taking a specific course to see the performance of previous students in that course as average gpa and proportion of A's. Students can select a course based on the subject, course level and professor. This app can help students to choose courses that they are more likely to do well in. It can also help students avoid taking course with professors whose students perform worse historically. If a course has multiple professors, students can use the app to choose which professor has the best performing students.

## Data

This data was obtained from Wade Fagen's github, at https://github.com/wadefagen/datasets/tree/master/gpa. It includes the grades of students in every course provided at UIUC from spring 2010 to spring 2021. Each row represents an individual course taken at U of I. The year and term column indicate when the course was taken. The subject column indicates the course subject and the number column indicates the course number. The columns named A-F with plus and minus contain the number of students that earned each grade respectively. I used dplyr to calculate and add the columns proportion of A's and average GPA.

## References

Wade Fagen. UIUC GPA Dataset. https://github.com/wadefagen/datasets/tree/master/gpa
