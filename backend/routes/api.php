<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoriesController;
use App\Http\Controllers\Api\ProductsController;
use App\Http\Controllers\Api\CartsController;

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
    Route::post('/categories/store', [CategoriesController::class, 'store']);
    Route::get('/categories/detail/{categories}', [CategoriesController::class, 'detail']);
    Route::post('/categories/update/{categories}', [CategoriesController::class, 'update']);
    Route::delete('/categories/delete/{categories}', [CategoriesController::class, 'delete']);

    // Product
    Route::get('/products', [ProductsController::class, 'index']);
    Route::post('/products/store', [ProductsController::class, 'store']);
    Route::get('/products/detail/{products}', [ProductsController::class, 'detail']);
    Route::post('/products/update/{products}', [ProductsController::class, 'update']);
    Route::delete('/products/delete/{products}', [ProductsController::class, 'delete']);
    Route::get('/products/{categories_id}', [ProductsController::class, 'products_categories']);

    // Cart
    Route::get('/carts/index', [CartsController::class, 'index']);
    Route::post('/carts/store', [CartsController::class, 'store']);
    Route::post('/carts/update/{carts}', [CartsController::class, 'update']);
    Route::delete('/carts/delete/{carts}', [CartsController::class, 'delete']);

    Route::post('/logout', [AuthController::class, 'logout']);
});