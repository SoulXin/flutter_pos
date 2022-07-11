<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Products;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProductsController extends Controller
{
    public function index(Request $request ){
        $data = $request->user()->products()->get();

        $this->response->data = $data;
        return $this->json();
    }

    public function store(Request $request) {
        $rules = [
            'name' => 'required|string|unique:products,name',
            'price' => 'required|min:1'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $newProducts = new Products;
        $newProducts->user_id = $request->user()->id;
        $newProducts->name = $request->name;
        $newProducts->price = $request->price;
        $newProducts->categories_id = $request->categories_id;
        $newProducts->save();

        $this->response->message = __('resources.create_success');
        return $this->json();
    }

    public function detail(Products $products){
        $this->response->data = $products;
        return $this->json();
    }

    public function update(Request $request, Products $products){
        $rules = [
            'name' => 'required|string',
            'price' => 'required|min:1'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $products->name = $request->name;
        $products->price = $request->price;
        $products->categories_id = $request->categories_id;

        $products->save();

        $this->response->message = __('resources.update_success');
        return $this->json();
    }

    public function delete(Products $products){
        $products->delete();

        $this->response->message = __('resources.delete_success');
        return $this->json();
    }

    public function products_categories( $categories_id){
        $data = Products::where('categories_id', '=', $categories_id)->get();

        $this->response->data = $data;
        return $this->json();
    }
}
