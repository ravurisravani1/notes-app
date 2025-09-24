const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const notesRoutes = require('./routes/notes');

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.use('/notes', notesRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
