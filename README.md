# Get-LabCode
## Parse Microsoft Training Lab sites for code snippets

Quick-n-dirty script to quickly get the code snippets from a lab when you are sitting in a MS training.

It scans the HTML code for <code> tags and lines with "Task x:" and returns the code of the tasks, and only the tasks with code parts.

When you are working with VSCode you can even get the tasks as #regions.
