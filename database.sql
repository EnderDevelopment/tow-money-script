CREATE TABLE IF NOT EXISTS tow_money (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    last_tow_time INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES users(identifier)
);