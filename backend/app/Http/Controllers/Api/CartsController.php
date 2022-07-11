<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Carts;

class CartsController extends Controller
{
    public function index(Request $request){
        $data = $request->user()->carts()->with('products')->get();

        $this->response->data = $data;
        return $this->json();
    }

    public function store(Request $request){
        $rules = [
            'products_id' => 'required',
            'quantity' => 'required'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors()->first();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $carts = new Carts($request->all());
        $carts->user_id = $request->user()->id;
        $carts->save();

        $this->response->data = $carts;
        $this->response->message = __('resources.create_success');
        return $this->json();
    }

    public function update(Request $request, Carts $carts){
        $rules = [
            'quantity' => 'required'
        ];

        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            $this->code = 400;
            $this->response->status = false;
            $this->response->message = $validator->errors()->first();
            $this->response->errors = $validator->fails();
            return $this->json();
        }

        $carts->fill($request->all());
        $carts->save();

        $this->response->message = __('resources.update_success');
        return $this->json();
    }

    public function delete(Carts $carts){
		$carts->delete();
		$this->response->message = __('resources.delete_success');

		return $this->json();
    }
}
