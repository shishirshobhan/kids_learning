<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>CRUD operation on Image</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
    <style>
        .style1{
            width: 50px;
            height: 50px;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div style="display:flex"  class="container mt-3 pt-5">
        <form action= "{{route('update',$item->id)}}" method="POST" enctype="multipart/form-data">
            {{csrf_field()}}
            <h1>CRUD OPERATION USING IMAGES</h1>
            <div class="mb-3">
                <label  class="form-label">image</label>
                <input type="file" name="image" class="form-control" value="{{$item['image']}}" id="image" aria-describedby="emailHelp">
            </div>
            <div class="mb-3">
                <label  class="form-label">sound</label>
                <input type="file" name="sound" class="form-control" value="{{$item['sound']}}" id="sound" aria-describedby="emailHelp">
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
        </form>
      </div>
</body>
</html>