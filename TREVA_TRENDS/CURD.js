import dbconnect from '@/lib/dbconnect';
import Product from '@/models/Product';

export default async function handler(req, res){
    const { method } = req;
    await dbconnect();

    try{

        switch(method){
            case 'GET':
                const productinfo = await Product.find();
                res.status(200).json(productinfo);
                break;

            case 'POST':
                const productcreate = await Product.create(req.body);
                res.status(201).json(productcreate);
                break;
                
            case 'PUT':
                const productupdate = await Product.findByIdAndUpdate(req.query.id, req.body, {new: true});
                res.status(200).json(productupdate);
                break;

            case 'PATCH':
                const patchproduct = await Product.findByIdAndUpdate(req.query.id, {$set: req.body}, {new: true, runValidators: true});
                res.status(200).json(patchproduct);
                break;

            case 'DELETE':
                await Product.findByIdAndDelete(req.query.id);
                res.status(204).end();
                break;
            
            default:
                res.setHeader("Allow", ["GET", "PUT", "POST", "PATCH", "DELETE"]);
                res.status(405).end(`Method ${method} Not Allowed`);

        }

    }catch(error){
        res.status(500).json({error: error.message});
    }
}



///Suppose this is in my api/products.js, then I can access it in my frontend like this:

//POST COMMAND

fetch ('api/products', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body:JSON.stringify({name: 'Laptop', price: 1000, description: 'A high-end gaming laptop'})
})
.then(res => res.json())
.then(data => console.log(data));

//GET COMMAND

fetch('/api/products')
    .then(res => res.json())
    .then(data => console.log(data));

//PUT COMMAND

fetch('/api/products?id=12345', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({name: 'Updated Laptop', price: 1200, description: 'An updated high-end gaming laptop'})
})
.then(res => res.json())
.then(data => console.log(data));

//PATCH COMMAND`
fetch('/api/products?id=12345', {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({price: 1100})
})
.then(res => res.json())
.then(data => console.log(data));


//DELETE COMMAND

fetch('/api/products?id=12345', {
    method: 'DELETE'
})
.then(res => {
    if (res.status === 204) {
        console.log('Product deleted successfully');
    } else {        
        console.error('Failed to delete product');
    }})
.catch(error => console.error('Error:', error));