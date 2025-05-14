const Booking = require('../models/Booking');

async function hasConflict(start, end, excludeId) {
  const query = {
    $or: [
      { startTime: { $lt: end, $gte: start } },
      { endTime:   { $gt:  start, $lte: end } },
      { startTime: { $lte: start }, endTime: { $gte: end } }
    ]
  };
  if (excludeId) {
    query._id = { $ne: excludeId };
  }
  return Booking.findOne(query);
}

exports.getAll = async (req, res, next) => {
  try {
    const list = await Booking.find().sort('startTime');
    res.json(list);
  } catch (err) {
    console.error(err);
    next({ status: 500, message: 'Server error' });
  }
};

exports.getById = async (req, res, next) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return res.status(404).json({ error: 'Booking not found' });
    res.json(booking);
  } catch (err) {
    console.error(err);
    next({ status: 500, message: 'Server error' });
  }
};

exports.create = async (req, res, next) => {
  try {
    const { bookingTitle, startTime, endTime } = req.body;
    const start = new Date(startTime);
    const end   = new Date(endTime);

    if (isNaN(start) || isNaN(end) || start >= end) {
      return res.status(400).json({ error: 'Invalid or illogical times' });
    }

    const conflict = await hasConflict(start, end);
    if (conflict) {
      return res.status(409).json({ error: 'Time slot already booked' });
    }

    const booking = await Booking.create({ bookingTitle, startTime: start, endTime: end });
    res.status(201).json(booking);

  } catch (err) {
    console.error(err);
    next({ status: 500, message: 'Server error' });
  }
};

exports.update = async (req, res, next) => {
  try {
    const { startTime, endTime } = req.body;
    const start = new Date(startTime);
    const end   = new Date(endTime);

    if (isNaN(start) || isNaN(end) || start >= end) {
      return res.status(400).json({ error: 'Invalid or illogical times' });
    }

    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const conflict = await hasConflict(start, end, booking._id);
    if (conflict) {
      return res.status(409).json({ error: 'Time slot already booked' });
    }

    booking.startTime = start;
    booking.endTime   = end;
    await booking.save();
    res.json(booking);

  } catch (err) {
    console.error(err);
    next({ status: 500, message: 'Server error' });
  }
};

exports.delete = async (req, res, next) => {
  try {
    const booking = await Booking.findByIdAndDelete(req.params.id);
    if (!booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    res.status(204).end();
  } catch (err) {
    console.error(err);
    next({ status: 500, message: 'Server error' });
  }
};
