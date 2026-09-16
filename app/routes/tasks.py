from flask import Blueprint, request, jsonify
from datetime import datetime

tasks_bp = Blueprint('tasks', __name__)

tasks = []

@tasks_bp.route("/", methods=["GET"])
def get_tasks():
    return jsonify({
        "total_tasks": len(tasks),
        "tasks": tasks
    })

@tasks_bp.route("/", methods=["POST"])
def add_task():
    data = request.get_json()

    new_task = {
        "id": len(tasks) + 1,
        "task": data.get("task"),
        "created_at": datetime.utcnow().isoformat()
    }

    tasks.append(new_task)

    return jsonify({
        "message": "Task added successfully 🚀",
        "task": new_task
    }), 201


@tasks_bp.route("/<int:id>", methods=["DELETE"])
def delete_task(id):
    global tasks
    tasks = [t for t in tasks if t["id"] != id]

    return jsonify({"message": "Task deleted 🗑️"})

