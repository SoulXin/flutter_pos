<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoriesController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login',[AuthController::class, 'login']);
Route::post('register',[AuthController::class, 'register']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::get('profile', function(Request $request) {
        return auth()->user();
    });

    // Category
    Route::get('/categories', [CategoriesController::class, 'index']);
    Route::get('/categories/{categories}', [CategoriesController::class, 'get_categories_product']);
    Route::post('/categories/store', [CategoriesController::class, 'store']);
    Route::post('/categories/update/{categories}', [CategoriesController::class, 'update']);
    Route::post('/categories/delete/{categories}', [CategoriesController::class, 'delete']);

    Route::post('/logout', [AuthController::class, 'logout']);
});