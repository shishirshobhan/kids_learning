<?php
namespace App\Http\Controllers;
use App\Models\learning;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [HomeController::class, 'index'])->name('home');

Route::post('/home', [LearningController::class, 'store'])->name('home.store');
Route::get('edit/{id}', [LearningController::class, 'edit'])->name('edit');
Route::post('update/{id}', [LearningController::class, 'update'])->name('update');
Route::get('delete/{id}', [LearningController::class, 'delete'])->name('delete');
