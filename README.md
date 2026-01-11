# Flow Field Pathfinding

This is a project I've been wanting to try since learning vector math in Calculus III. There are so many applications for vectors and flow fields in computer graphics, especially game development. I'm glad I finally got to try it and create an implementation worthy of a public repo. Dijkstra's algorithm makes up the bulk of the logic, with an added direction calculation by finding the cheapest neihgbor node at each cell. Made in Godot 4.5, utilizing GDScript for its simplicity and Python like behavior, which makes prototyping and testing easy. Godot also offers visuality right off rip as its a game engine by heart. I even added a little red square which could represent a unique entity seeking out the player target. There is a demonstration of the project shown below. I might keep adding complexity such as obstacles, hordes of pathfinding entities, and will keep the demo updated.

![Image](https://github.com/user-attachments/assets/e96a5c18-6a84-4187-aa25-fbee1b98f99c)

If you want to pull the repo to make changes, just make sure to have Godot 4.5 or above installed and import the project.godot file in engine.

1/10/26: Added obstacle navigation and attempted to add multiple enemies on screen. It works alright, but the enemies group up in a line. This is less than optimal, so I will most likely change that at some point. Anyway, here's the most recent demo.

![Image](https://github.com/user-attachments/assets/12acaa0c-cf41-4ffa-9095-3d5560c57c6a)
