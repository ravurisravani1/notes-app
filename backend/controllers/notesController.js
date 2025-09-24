const db = require('../db/index');
const { v4: uuidv4 } = require('uuid');

exports.getAll = async (req, res) => {
  try {
    const [rows] = await db.execute('SELECT * FROM notes ORDER BY created_at DESC');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.create = async (req, res) => {
  try {
    const { title, description } = req.body;
    if (!title) return res.status(400).json({ error: 'Title is required' });
    const id = uuidv4();
    await db.execute('INSERT INTO notes (id, title, description) VALUES (?, ?, ?)', [id, title, description]);
    const [rows] = await db.execute('SELECT * FROM notes WHERE id = ?', [id]);
    res.status(201).json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.update = async (req, res) => {
  try {
    const id = req.params.id;
    const { title, description, completed } = req.body;
    const [result] = await db.execute(
      'UPDATE notes SET title=?, description=?, completed=?, updated_at=NOW() WHERE id=?',
      [title, description, completed, id]
    );
    const [rows] = await db.execute('SELECT * FROM notes WHERE id=?', [id]);
    if (!rows.length) return res.status(404).json({ error: 'Note not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.delete = async (req, res) => {
  try {
    const id = req.params.id;
    const [result] = await db.execute('DELETE FROM notes WHERE id=?', [id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Note not found' });
    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
};
