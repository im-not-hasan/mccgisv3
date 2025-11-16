<?php

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;
use App\Http\Controllers\CustomLoginController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\SettingsController;
use App\Http\Controllers\SubjectsController;
use App\Http\Controllers\InstructorsController;
use App\Http\Controllers\ClassesController;
use App\Http\Controllers\StudentsController;
use App\Http\Controllers\IrregStudentSubjectController;
use App\Http\Controllers\GradeController;
use App\Http\Controllers\GradeSheetController;
use App\Http\Controllers\StudentImportExportController;
use App\Http\Controllers\InstructorLoadImportController;
use App\Http\Controllers\TORController;
use App\Http\Controllers\BackupController;
use App\Http\Controllers\LoginLogController;




// Root: Show login page or redirect based on session
Route::get('/', function () {
    $level = Session::get('level');

    return match ($level) {
        'admin', 'teacher', 'student' => redirect('/dashboard'),
        default => Inertia::render('Auth/Login'),
    };
})->name('login');


// Session fetch route for Vue to get session data
Route::get('/session', function () {
    $source = request()->query('source', 'unknown');

    if ($source === 'gradeentry') {
        Log::info('Session called from GradeEntry page.', Session::all());
    }
    $fullname = Session::get('fullname');
    $username = Session::get('username');
    $level = Session::get('level');

    Log::info('Session accessed:', [
        'fullname' => $fullname,
        'username' => $username,
        'level' => $level,
    ]);

    return response()->json([
        'fullname' => $fullname,
        'username' => $username,
        'level' => $level,
    ]);
});

// Routes to Pages
Route::get('/dashboard', fn () => Inertia::render('Dashboard'))->name('dashboard')->middleware('ensure.logged');
Route::get('/students', fn () => Inertia::render('Students'))->name('students')->middleware('ensure.logged');
Route::get('/instructors', fn () => Inertia::render('Instructors'))->name('instructors')->middleware('ensure.logged');
Route::get('/classes', fn () => Inertia::render('Classes'))->name('classes')->middleware('ensure.logged');
Route::get('/subjects', fn () => Inertia::render('Subjects'))->name('subjects')->middleware('ensure.logged');
Route::get('/consultation', fn () => Inertia::render('Consultation'))->name('consultation')->middleware('ensure.logged');
Route::get('/settings', fn () => Inertia::render('Settings'))->name('settings')->middleware('ensure.logged');
Route::get('/terms', function () {return inertia('Terms');});
Route::get('/viewgrades', fn () => Inertia::render('ViewGrades'))->name('viewgrades')->middleware('ensure.logged:student');


// Login and Logout
Route::post('/custom-login', [CustomLoginController::class, 'login'])->name('custom.login');
Route::post('/check-user-email', [CustomLoginController::class, 'checkUserEmail']);
Route::post('/forgot-password', [CustomLoginController::class, 'forgotPassword']);
Route::post('/verify-otp', [CustomLoginController::class, 'verifyOtp']);
Route::post('/reset-password', [CustomLoginController::class, 'resetPassword']);

Route::post('/logout', [CustomLoginController::class, 'logout'])->name('logout');


// Dashboard Counts
Route::get('/dashboard-counts', [DashboardController::class, 'getCounts'])->middleware('ensure.logged');









// Subject
// Subject Counts
Route::get('/subject-counts', [SubjectsController::class, 'getSubjectCountsByCourse'])->middleware('ensure.logged');

//View Subjects by Course
Route::get('/subjects/{course}', function ($course) {
return Inertia::render('CourseSubjects', ['course' => $course]);
})->middleware('ensure.logged:admin|registrar');
Route::get('/api/subjects/{course}', [SubjectsController::class, 'getSubjectsByCourse'])->middleware('ensure.logged:admin|registrar');
Route::get('/api/allsubjects/{course}', [SubjectsController::class, 'getAllSubjectsByCourse'])->middleware('ensure.logged:admin|registrar');

//Save Subject
Route::post('/subjects', [SubjectsController::class, 'store'])->middleware('ensure.logged:admin');
//Delete Subject
Route::delete('/subjects/{id}', [SubjectsController::class, 'destroy'])->middleware('ensure.logged:admin');
//Update Subject
Route::put('/subjects/{id}', [SubjectsController::class, 'update'])->middleware('ensure.logged:admin');


//Irreg Subject 

Route::post('/api/irregstudentsubject', [IrregStudentSubjectController::class, 'store'])->middleware('ensure.logged:admin');
Route::put('/api/irregstudentsubject/{studid}', [IrregStudentSubjectController::class, 'update'])->middleware('ensure.logged:admin');
Route::get('/api/irregstudentsubject/{studid}', [IrregStudentSubjectController::class, 'getStudentSubjects'])->middleware('ensure.logged');












//Instructors
Route::get('/instructor-stats', [InstructorsController::class, 'getInstructorStats'])->middleware('ensure.logged:admin');
//View Instructors by Course
Route::get('/api/instructors/{department}', [InstructorsController::class, 'getInstructorsByDepartment'])->middleware('ensure.logged:admin');
Route::get('/instructors/{department}', function ($department) {
    return Inertia::render('CourseInstructors', [
        'department' => $department,
    ]);
})->middleware('ensure.logged:admin');
// Save Instructor
Route::post('/instructors', [InstructorsController::class, 'store'])->middleware('ensure.logged:admin');

// Update Instructor
Route::put('/instructors/{id}', [InstructorsController::class, 'update'])->middleware('ensure.logged:admin');

// Delete Instructor
Route::delete('/instructors/{id}', [InstructorsController::class, 'destroy'])->middleware('ensure.logged:admin');

// Check if ID Exists
Route::get('/api/instructors/check/{teachid}', [InstructorsController::class, 'checkTeachid'])->middleware('ensure.logged:admin');

// Assign Subjects to Instructor
Route::post('/instructors/{id}/assign-subject', [InstructorsController::class, 'assignSubject'])->middleware('ensure.logged:admin');
Route::get('/api/instructors/{id}/assignments', [InstructorsController::class, 'getAssignments'])->middleware('ensure.logged:admin');
Route::post('/api/instructors/assignments', [InstructorsController::class, 'storeAssignment'])->middleware('ensure.logged:admin');
Route::delete('/instructors/{instructor}/assignments/{assignment}', [InstructorsController::class, 'deleteAssignment'])->middleware('ensure.logged:admin');

//Assign by Importing Instructor Load
Route::post('/imports/instructor-loads', [InstructorLoadImportController::class, 'import'])
     ->name('imports.instructor-loads')->middleware('ensure.logged:admin');


// View Assigned Subjects (TeacherClasses) (Same being used for TeacherSubjects)
Route::get('/teacher-classes', [InstructorsController::class, 'teacherClasses'])->middleware('ensure.logged:teacher');

// View Students in Class (Teacher) 
Route::get('/students/by-class', [ClassesController::class, 'getStudentsByClass'])->middleware('ensure.logged:teacher');






//Classes
Route::get('/class-stats', [ClassesController::class, 'getStats'])->middleware('ensure.logged:admin|registrar');

//View All Classes
Route::get('/view-classes', fn () => Inertia::render('ViewClasses'))->name('viewclasses')->middleware('ensure.logged:admin|registrar');

// API for classes
Route::get('/api/classes', [ClassesController::class, 'index'])->middleware('ensure.logged:admin|registrar');
Route::post('/classes', [ClassesController::class, 'store'])->middleware('ensure.logged:admin');
Route::put('/classes/{id}', [ClassesController::class, 'update'])->middleware('ensure.logged:admin');
Route::delete('/classes/{id}', [ClassesController::class, 'destroy'])->middleware('ensure.logged:admin');


Route::get('/classes/{id}/students', [ClassesController::class, 'getClassStudents'])->middleware('ensure.logged:admin');
Route::post('/classes/{id}/students', [ClassesController::class, 'addStudentToClass'])->middleware('ensure.logged:admin');
Route::delete('/classes/{classId}/students/{studentId}', [ClassesController::class, 'removeStudentFromClass'])->middleware('ensure.logged:admin');

// Registrar - View Subjects in Class
Route::get('/classes/{id}/subjects', [ClassesController::class, 'getClassSubjects'])->middleware('ensure.logged:registrar');
Route::get('/registrar/dashboard', [DashboardController::class, 'registrarDashboard'])->middleware('ensure.logged:registrar');
Route::get('/tor-requests', function () {
    return Inertia::render('TOR_Requests', [
    ]);
})->middleware('ensure.logged:registrar');



//Students
Route::get('/student-stats', [StudentsController::class, 'getStudentStats'])->middleware('ensure.logged:admin|registrar');

//View All Students
Route::get('/students/all', function () {
    return Inertia::render('AllStudents', [
    ]);
})->middleware('ensure.logged:admin|registrar');
Route::get('/api/allstudents/', [StudentsController::class, 'getAllStudents'])->middleware('ensure.logged:admin|registrar'); //Fetching Data
//Export/Import
Route::middleware(['web'])->group(function () {
    Route::get('/students/template/export', [StudentImportExportController::class, 'exportTemplate'])->name('students.template.export')->middleware('ensure.logged:admin');
    Route::post('/students/template/import', [StudentImportExportController::class, 'import'])->name('students.template.import')->middleware('ensure.logged:admin');
});





// View Students by Course
Route::get('/api/students/{course}', [StudentsController::class, 'getStudentsByCourse'])->middleware('ensure.logged:admin|registrar'); //Fetching Data
Route::get('/students/{course}', function ($course) { //Actual Page
    return Inertia::render('CourseStudents', [
        'course' => $course,
    ]);
})->middleware('ensure.logged:admin|registrar');


// Save Student
Route::post('/students', [StudentsController::class, 'store'])->middleware('ensure.logged:admin');

// Update Student
Route::put('/students/{id}', [StudentsController::class, 'update'])->middleware('ensure.logged:admin');

// Delete Student
Route::delete('/students/{id}', [StudentsController::class, 'destroy'])->middleware('ensure.logged:admin');

// Get Student Details (for dashboard)
Route::get('/student/dashboard', [DashboardController::class, 'studentDashboard'])->middleware('ensure.logged');

// View Students' Subjects
Route::get('/student-subjects', [StudentsController::class, 'studentSubjects'])->middleware('ensure.logged');

Route::get('/api/sections', [StudentsController::class, 'getSections'])->middleware('ensure.logged');
Route::get('/api/academicyears', [StudentsController::class, 'getAcademicYears'])->middleware('ensure.logged');

// Check if ID Exists
Route::get('/api/students/check/{studid}', [StudentsController::class, 'checkStudid'])->middleware('ensure.logged');




// Settings 

// Academic Year
Route::get('/ay', [SettingsController::class, 'getAY'])->middleware('ensure.logged:admin');
Route::post('/ay/toggle-display', [SettingsController::class, 'toggleDisplay'])->middleware('ensure.logged:admin');
Route::delete('/ay/{id}', [SettingsController::class, 'deleteAcademicYear'])->middleware('ensure.logged:admin');
Route::post('/settings/academic-year', [SettingsController::class, 'storeAcademicYear'])->middleware('ensure.logged:admin');

// Change Pass
Route::post('/settings/update-password', [SettingsController::class, 'updatePassword'])->middleware('ensure.logged');

// Curriculum
Route::get('/curriculums', [SettingsController::class, 'getCurriculums'])->middleware('ensure.logged:admin');
Route::post('/settings/curriculum', [SettingsController::class, 'storeCurriculum'])->middleware('ensure.logged:admin');
Route::post('/curriculums/toggle-display', [SettingsController::class, 'toggleCurriculumDisplay'])->middleware('ensure.logged:admin');
Route::delete('/curriculums/{id}', [SettingsController::class, 'deleteCurriculum'])->middleware('ensure.logged:admin');


// Logs for Admin
Route::get('/admin/login-logs', [LoginLogController::class, 'index'])->middleware('ensure.logged:admin');
Route::get('/admin/logs/geolocate', [LoginLogController::class, 'geolocate'])->middleware('ensure.logged:admin');



// Grade Entry
Route::get('/grades-entry', function () {
return Inertia::render('GradeEntry');
})->name('grades.entry')->middleware('ensure.logged:teacher');


// Fetch students and existing grades for a class-subject
Route::get('/grades/{subject_id}/{course}/{year}/{section}', [GradeController::class, 'getGrades'])->middleware('ensure.logged:teacher');
Route::get('/finalgrades/{subject_id}/{course}/{year}/{section}', [GradeController::class, 'getFinalGrades'])->middleware('ensure.logged:teacher');
// Save as draft (temporary save)
Route::post('/grades/save', [GradeController::class, 'saveGrades'])->name('grades.save')->middleware('ensure.logged:teacher');
Route::post('/finalgrades/save', [GradeController::class, 'saveFinalGrades'])->name('grades.save')->middleware('ensure.logged:teacher');
// Submit final grades (locked)
Route::post('/grades/submit', [GradeController::class, 'submitGrades'])->middleware('ensure.logged:teacher');






// API - Active Semester
Route::get('/api/active-ay', function () {
    $activeAY = DB::table('ay')->where('display', 1)->first();
    if ($activeAY) {
        return response()->json($activeAY);
    }
    return response()->json(null, 404);
})->middleware('ensure.logged');



// Grade Sheet
Route::get('/gradesheet/print', [GradeSheetController::class, 'print'])->name('gradesheet.print')->middleware('ensure.logged:registrar');


// TOR
// Student requests TOR
Route::post('/tor/request', [TORController::class, 'requestTOR'])
    ->name('tor.request')->middleware('ensure.logged:student');
Route::get('/tor-requests/all', [TORController::class, 'allRequests'])->middleware('ensure.logged:registrar');
Route::post('/tor-requests/{id}/update-status', [TORController::class, 'updateStatus'])->middleware('ensure.logged:registrar');
Route::get('/tor-requests/{id}/student-info', [TORController::class, 'getStudentInfo'])->middleware('ensure.logged:registrar');
Route::post('/tor-requests/save-student-info', [TORController::class, 'saveStudentInfo'])->middleware('ensure.logged:registrar');
Route::get('/tor/print/{request_id}', [TORController::class, 'print'])->name('tor.print')->middleware('ensure.logged:registrar');


Route::get('/pukcabbd', function () {
    return Inertia::render('Backup');
})->name('backup.page')->middleware('ensure.logged:admin');
Route::get('/ldpukcabbd', [BackupController::class, 'download'])
    ->name('backup.download')->middleware('ensure.logged:admin');





// View Grades (for students)
Route::get('/student/viewgrades/data', [StudentsController::class, 'viewGradesData'])
    ->name('student.viewgrades.data')->middleware('ensure.logged');
// Download Grades
Route::get('/viewgrades/download', [StudentsController::class, 'downloadGradeSlip'])->middleware('ensure.logged:student');
