///****JET authentication***///

import jwt from 'jsonwebtoken';

const token = jwt.sign(
    {id: user.id, email: user.email, role: user.role},
    process.env.JWT_TOKEN,
    {expiresIn : "1h"}
);


export function verifytoken(req){
    const token = req.headers.authorization

    if(!token) throw new Error("Unauthorized");

    try{
        const tokens = token.split(" ")[1];
        return jwt.verify(tokens, process.env.JWT_TOKEN);
    }catch(error){
        throw new Error("Server Error");
    }
}