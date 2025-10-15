<?php

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Session;
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
Route::get('/dashboard', fn () => Inertia::render('Dashboard'))->name('dashboard');
Route::get('/students', fn () => Inertia::render('Students'))->name('students');
Route::get('/instructors', fn () => Inertia::render('Instructors'))->name('instructors');
Route::get('/classes', fn () => Inertia::render('Classes'))->name('classes');
Route::get('/subjects', fn () => Inertia::render('Subjects'))->name('subjects');
Route::get('/consultation', fn () => Inertia::render('Consultation'))->name('settings');
Route::get('/generatereports', fn () => Inertia::render('GenerateReports'))->name('generatereports');
Route::get('/settings', fn () => Inertia::render('Settings'))->name('settings');
Route::get('/terms', function () {return inertia('Terms');});



// Login and Logout
Route::post('/custom-login', [CustomLoginController::class, 'login'])->name('custom.login');
Route::post('/check-user-email', [CustomLoginController::class, 'checkUserEmail']);
Route::post('/forgot-password', [CustomLoginController::class, 'forgotPassword']);
Route::post('/verify-otp', [CustomLoginController::class, 'verifyOtp']);
Route::post('/reset-password', [CustomLoginController::class, 'resetPassword']);

Route::post('/logout', function () {
    Auth::logout();
    request()->session()->invalidate();
    request()->session()->regenerateToken();
    return redirect()->to('/');
})->name('logout');



// Dashboard Counts
Route::get('/dashboard-counts', [DashboardController::class, 'getCounts']);









// Subject
// Subject Counts
Route::get('/subject-counts', [SubjectsController::class, 'getSubjectCountsByCourse']);

//View Subjects by Course
Route::get('/subjects/{course}', function ($course) {
return Inertia::render('CourseSubjects', ['course' => $course]);
});
Route::get('/api/subjects/{course}', [SubjectsController::class, 'getSubjectsByCourse']);
Route::get('/api/allsubjects/{course}', [SubjectsController::class, 'getAllSubjectsByCourse']);

//Save Subject
Route::post('/subjects', [SubjectsController::class, 'store']);
//Delete Subject
Route::delete('/subjects/{id}', [SubjectsController::class, 'destroy']);
//Update Subject
Route::put('/subjects/{id}', [SubjectsController::class, 'update']);


//Irreg Subject 

Route::post('/api/irregstudentsubject', [IrregStudentSubjectController::class, 'store']);
Route::put('/api/irregstudentsubject/{studid}', [IrregStudentSubjectController::class, 'update']);
Route::get('/api/irregstudentsubject/{studid}', [IrregStudentSubjectController::class, 'getStudentSubjects']);












//Instructors
Route::get('/instructor-stats', [InstructorsController::class, 'getInstructorStats']);
//View Instructors by Course
Route::get('/api/instructors/{department}', [InstructorsController::class, 'getInstructorsByDepartment']);
Route::get('/instructors/{department}', function ($department) {
    return Inertia::render('CourseInstructors', [
        'department' => $department,
    ]);
});
// Save Instructor
Route::post('/instructors', [InstructorsController::class, 'store']);

// Update Instructor
Route::put('/instructors/{id}', [InstructorsController::class, 'update']);

// Delete Instructor
Route::delete('/instructors/{id}', [InstructorsController::class, 'destroy']);

// Check if ID Exists
Route::get('/api/instructors/check/{teachid}', [InstructorsController::class, 'checkTeachid']);

// Assign Subjects to Instructor
Route::post('/instructors/{id}/assign-subject', [InstructorsController::class, 'assignSubject']);
Route::get('/api/instructors/{id}/assignments', [InstructorsController::class, 'getAssignments']);
Route::post('/api/instructors/assignments', [InstructorsController::class, 'storeAssignment']);
Route::delete('/instructors/{instructor}/assignments/{assignment}', [InstructorsController::class, 'deleteAssignment']);

//Assign by Importing Instructor Load
Route::post('/imports/instructor-loads', [InstructorLoadImportController::class, 'import'])
     ->name('imports.instructor-loads');


// View Assigned Subjects (TeacherClasses) (Same being used for TeacherSubjects)
Route::get('/teacher-classes', [InstructorsController::class, 'teacherClasses']);

// View Students in Class (Teacher) 
Route::get('/students/by-class', [ClassesController::class, 'getStudentsByClass']);






//Classes
Route::get('/class-stats', [ClassesController::class, 'getStats']);

//View All Classes
Route::get('/view-classes', fn () => Inertia::render('ViewClasses'))->name('viewclasses');

// API for classes
Route::get('/api/classes', [ClassesController::class, 'index']);
Route::post('/classes', [ClassesController::class, 'store']);
Route::put('/classes/{id}', [ClassesController::class, 'update']);
Route::delete('/classes/{id}', [ClassesController::class, 'destroy']);


Route::get('/classes/{id}/students', [ClassesController::class, 'getClassStudents']);
Route::post('/classes/{id}/students', [ClassesController::class, 'addStudentToClass']);
Route::delete('/classes/{classId}/students/{studentId}', [ClassesController::class, 'removeStudentFromClass']);

// Registrar - View Subjects in Class
Route::get('/classes/{id}/subjects', [ClassesController::class, 'getClassSubjects']);
Route::get('/registrar/dashboard', [DashboardController::class, 'registrarDashboard']);
Route::get('/tor-requests', function () {
    return Inertia::render('TOR_Requests', [
    ]);
});



//Students
Route::get('/student-stats', [StudentsController::class, 'getStudentStats']);

//View All Students
Route::get('/students/all', function () {
    return Inertia::render('AllStudents', [
    ]);
});
Route::get('/api/allstudents/', [StudentsController::class, 'getAllStudents']); //Fetching Data
//Export/Import
Route::middleware(['web'])->group(function () {
    Route::get('/students/template/export', [StudentImportExportController::class, 'exportTemplate'])->name('students.template.export');
    Route::post('/students/template/import', [StudentImportExportController::class, 'import'])->name('students.template.import');
});





// View Students by Course
Route::get('/api/students/{course}', [StudentsController::class, 'getStudentsByCourse']); //Fetching Data
Route::get('/students/{course}', function ($course) { //Actual Page
    return Inertia::render('CourseStudents', [
        'course' => $course,
    ]);
});


// Save Student
Route::post('/students', [StudentsController::class, 'store']);

// Update Student
Route::put('/students/{id}', [StudentsController::class, 'update']);

// Delete Student
Route::delete('/students/{id}', [StudentsController::class, 'destroy']);

// Get Student Details (for dashboard)
Route::get('/student/dashboard', [DashboardController::class, 'studentDashboard']);

// View Students' Subjects
Route::get('/student-subjects', [StudentsController::class, 'studentSubjects']);

Route::get('/api/sections', [StudentsController::class, 'getSections']);
Route::get('/api/academicyears', [StudentsController::class, 'getAcademicYears']);

// Check if ID Exists
Route::get('/api/students/check/{studid}', [StudentsController::class, 'checkStudid']);




// Settings 

// Academic Year
Route::get('/ay', [SettingsController::class, 'getAY']);
Route::post('/ay/toggle-display', [SettingsController::class, 'toggleDisplay']);
Route::delete('/ay/{id}', [SettingsController::class, 'deleteAcademicYear']);
Route::post('/settings/academic-year', [SettingsController::class, 'storeAcademicYear']);

// Change Pass
Route::post('/settings/update-password', [SettingsController::class, 'updatePassword']);

// Curriculum
Route::get('/curriculums', [SettingsController::class, 'getCurriculums']);
Route::post('/settings/curriculum', [SettingsController::class, 'storeCurriculum']);
Route::post('/curriculums/toggle-display', [SettingsController::class, 'toggleCurriculumDisplay']);
Route::delete('/curriculums/{id}', [SettingsController::class, 'deleteCurriculum']);





// Grade Entry
Route::get('/grades-entry', function () {
return Inertia::render('GradeEntry');
})->name('grades.entry');


// Fetch students and existing grades for a class-subject
Route::get('/grades/{subject_id}/{course}/{year}/{section}', [GradeController::class, 'getGrades']);

// Save as draft (temporary save)
Route::post('/grades/save', [GradeController::class, 'saveGrades'])->name('grades.save');

// Submit final grades (locked)
Route::post('/grades/submit', [GradeController::class, 'submitGrades']);






// API - Active Semester
Route::get('/api/active-ay', function () {
    $activeAY = DB::table('ay')->where('display', 1)->first();
    if ($activeAY) {
        return response()->json($activeAY);
    }
    return response()->json(null, 404);
});



// Grade Sheet
Route::get('/gradesheet/print', [GradeSheetController::class, 'print'])->name('gradesheet.print');


// TOR
// Student requests TOR
Route::post('/tor/request', [TORController::class, 'requestTOR'])
    ->name('tor.request');
Route::get('/tor-requests/all', [TORController::class, 'allRequests']);
Route::post('/tor-requests/{id}/update-status', [TORController::class, 'updateStatus']);
Route::get('/tor-requests/{id}/student-info', [TORController::class, 'getStudentInfo']);
Route::post('/tor-requests/save-student-info', [TORController::class, 'saveStudentInfo']);
Route::get('/tor/print/{request_id}', [TORController::class, 'print'])->name('tor.print');
