DROP DATABASE IF EXISTS Graph_SQL;
CREATE DATABASE Graph_SQL;

USE Graph_SQL;

CREATE TABLE Graph (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 name VARCHAR(100)
);

CREATE TABLE Nodes (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 val CHAR,
			 graph_id INT,
			 FOREIGN KEY (graph_id) REFERENCES Graph(id)
);

CREATE TABLE Edges (
			 id INT AUTO_INCREMENT PRIMARY KEY,
			 node_1 INT, -- from
			 node_2 INT, -- to
			 FOREIGN KEY (node_1) REFERENCES Nodes(id),
			 FOREIGN KEY (node_2) REFERENCES Nodes(id)
);

-- Initialize Graph 'C' (Columbia)
INSERT INTO Graph (name) VALUES ("C");

-- Create a few nodes
INSERT INTO Nodes (graph_id, val) VALUES
((SELECT id from Graph WHERE name = "C"), 'a'),
((SELECT id from Graph WHERE name = "C"), 'b'),
((SELECT id from Graph WHERE name = "C"), 'd');

-- Connect the nodes
INSERT INTO Edges (node_1, node_2) VALUES ((SELECT id from Nodes where val = "a"), (SELECT id from Nodes where val = "b"));

INSERT INTO Edges (node_1, node_2) VALUES ((SELECT id from Nodes where val = "a"), (SELECT id from Nodes where val = "d"));

INSERT INTO Edges (node_1, node_2) VALUES ((SELECT id from Nodes where val = "b"), (SELECT id from Nodes where val = "d"));


-- SELECT * from Graph;
-- SELECT * from Nodes;
-- SELECT * from Edges;


-- SELECT E1.node_2 from Edges AS E1;

SELECT E1.node_1, E2.node_2 FROM Edges E1, Edges E2 WHERE E1.node_2 = E2.node_1;
