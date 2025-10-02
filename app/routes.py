from flask import Blueprint, render_template, request, jsonify, current_app
from app.tasks import run_gibbscluster_task
from celery.result import AsyncResult
from app.celery_app import celery
import tempfile
import os
import uuid

bp = Blueprint('main', __name__)

@bp.route('/')
def index():
    return render_template('index.html')

@bp.route('/submit', methods=['POST'])
def submit():
    # Your submit logic here
    pass

@bp.route('/status/<task_id>')
def task_status(task_id):
    task = AsyncResult(task_id, app=celery)
    # Return task status
    pass

@bp.route('/jobs')
def list_jobs():
    # List all jobs
    pass