<?php

namespace App\Http\Controllers;

use App\Models\learning;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;

class LearningController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
       
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'image'=>'required',
                'sound'=>'required'

            ]);
            $learning = new learning();
            if($request->file('image')){
                $file = $request->file('image');
                $filename= $file->getClientOriginalName();
                $file->move(public_path('image'), $filename); 
                $learning ['image']= $filename;

                if($request->file('sound')){
                    $files = $request->file('sound');
                    $filename1= $files->getClientOriginalName();
                    $files->move(public_path('sound'), $filename1); 
                    $learning ['sound']= $filename1;
                }
            }
            $learning->save();

        } catch (\Exception $e) {
            dd($e);
            return redirect()-> back()->with('error', 'there is error in'. $e);
        }
        return redirect()-> back();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\learning  $learning
     * @return \Illuminate\Http\Response
     */
    public function show(learning $learning)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\learning  $learning
     * @return \Illuminate\Http\Response
     */
    public function edit(learning $learning, $id)
    {
        $item = learning::find($id);
        return view('update', compact('item'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\learning  $learning
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, learning $learning, $id)
    {
        try {
            $request->validate([
                'image'=>'required',
                'sound'=>'required'

            ]);
            $learning = learning::find($id);
            if($request->file('image')){
                $file = $request->file('image');
                $filename= $file->getClientOriginalName();
                $file->move(public_path('image'), $filename); 
                $learning ['image']= $filename;

                if($request->file('sound')){
                    $files = $request->file('sound');
                    $filename1= $files->getClientOriginalName();
                    $files->move(public_path('sound'), $filename1); 
                    $learning ['sound']= $filename1;
                }
                
            }
            $learning->update();
            

        } catch (\Exception $e) {
            dd($e);
            return redirect()-> back()->with('error', 'there is error in'. $e);
        }
        return redirect()-> route('home');
    }

    public function delete(Request $request, $id){
        $data = learning::find($id);
        $destination1 ='image/'.$data->image;
        $destination2 ='sound/'.$data->sound;
        if(File::exists($destination1,$destination2)){

            File::delete($destination1,$destination2);
        }
        $data->delete();
        return redirect()->back();



    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\learning  $learning
     * @return \Illuminate\Http\Response
     */
    public function destroy(learning $learning)
    {
        //
    }
}
