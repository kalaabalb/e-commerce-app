const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Define schema and model first
const { Schema, model } = mongoose;
const userSchema = new Schema({
  name: String,
  age: Number,
  email: String
});
const User = model('User', userSchema);

// Connect to local MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/rapid')
  .then(() => console.log('Connected to local Database'))
  .catch(err => console.error('MongoDB connection error:', err));

// Route
// GET all users
app.get('/', async (req, res) => {
    const users = await User.find();
    res.json(users);
});

// POST a new user
app.post('/', async (req, res) => {
    try {
        const { name, age, email } = req.body;
        const newUser = new User({ name, age, email });
        await newUser.save();
        res.json('API is working');
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// Start server
app.listen(port, () => {
  console.log(`Server is running on :${port}`);
});

