const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  bookingTitle:    { type: String, required: true, trim: true },
  startTime: { type: Date,   required: true },
  endTime:   { type: Date,   required: true }
}, { timestamps: true });

module.exports = mongoose.model('Booking', bookingSchema);