<?php

namespace App\Http\Controllers;

use App\Models\Learning;
use Exception;
use Illuminate\Http\Request;

class ApiController extends Controller
{
    function allLearning()
    {
        $learning = Learning::all();
        return response([
            'status' => '200',
            'learning' => $learning,
        ]);
    }
    function create(Request $request)
    {

        try {
            $learning = new Learning();
            if($request->file('image')){
                $file = $request->file('image');
                $filename= $file->getClientOriginalName();
                $file->move(public_path('image'), $filename); 
                $learning ['image']= $filename;

                if($request->file('sound')){
                    $file = $request->file('sound');
                    $filename1= $file->getClientOriginalName();
                    $file->move(public_path('sound'), $filename); 
                    $learning ['sound']= $filename1;
                }
            }
            $learning->save();

            return response([
                'status' => '200'
            ]);
        } catch (Exception $exception) {
            return response([
                'status' => '400',
                'exception' => 'error' . $exception
            ]);
        }
    
    }

    function singleLearning($id)
    {
        $learning = Learning::find($id);

        return response([
            'status' => '200',
            'learning' => $learning,
        ]);
    }
}