<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Categories;

class CategoriesController extends Controller
{
    public function index(){
        $data = Categories::get();
        
        $this->response->data = $data;
        return $this->json();
    }

    public function get_categories_product(Categories $categories){
        $data = $categories->products()->get();

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
            $this->response->message = $validator->errors();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $newCategories = new Categories;
        $newCategories->users_id = 1;
        $newCategories->name = $request->name;
        $newCategories->save();

        return $this->json();
    }

    public function update(Request $request, $categories){
        $data = Categories::find($categories);

        if(is_null($data)){
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = "Data not found";
            $this->response->errors = true;
            return $this->json();
        } 

        $data->name = $request->name;
        $data->save();

        return $this->json();
    }

    public function delete($categories){
        $data = Categories::find($categories);

        if(is_null($data)){
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = "Data not found";
            $this->response->errors = true;
            return $this->json();
        } 

        $data->delete();
        return $this->json();
    }
}
