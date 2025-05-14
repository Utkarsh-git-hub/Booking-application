require('dotenv').config();
const express     = require('express');
const cors        = require('cors');
const connectDB   = require('./config/db');
const bookingRoutes = require('./routes/bookings');
const errorHandler  = require('./middleware/errorHandler');

const app = express();
app.use(cors());
app.use(express.json());
connectDB();

app.use('/bookings', bookingRoutes);

app.use(errorHandler);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server is running`));