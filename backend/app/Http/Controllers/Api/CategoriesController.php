<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Categories;

class CategoriesController extends Controller
{
    public function index(Request $request ){
        $data = $request->user()->categories()->get();
        
        $this->response->data = $data;
        return $this->json();
    }

    public function store(Request $request) {
        $rules = [
            'name' => 'required|string|unique:categories,name'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors()->first();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $newCategories = new Categories;
        $newCategories->user_id = 1;
        $newCategories->name = $request->name;
        $newCategories->save();

        $this->response->message = __('resources.create_success');
        return $this->json();
    }

    public function detail(Categories $categories){
        $this->response->data = $categories;
        return $this->json();
    }

    public function update(Request $request,Categories $categories){
        $rules = [
            'name' => 'required|string'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors()->first();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $categories->name = $request->name;
        $categories->save();

        $this->response->message = __('resources.update_success');
        return $this->json();
    }

    public function delete(Categories $categories){
        $categories->delete();

        $this->response->message = __('resources.delete_success');
        return $this->json();
    }
}
