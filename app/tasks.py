from app.celery_app import celery
from flask import current_app
import subprocess
from pathlib import Path
import os

@celery.task(bind=True)
def run_gibbscluster_task(self, job_dir, cmd, job_id):
    """
    Celery task to run GibbsCluster analysis
    """
    try:
        self.update_state(state='RUNNING', meta={
            'status': 'Running GibbsCluster analysis...',
            'job_id': job_id
        })
        
        # Run GibbsCluster
        result = subprocess.run(
            cmd,
            cwd=job_dir,
            capture_output=True,
            text=True,
            timeout=600
        )
        
        if result.returncode != 0:
            return {
                'status': 'error',
                'error': 'GibbsCluster failed',
                'stderr': result.stderr,
                'command': ' '.join(cmd),
                'job_id': job_id
            }
        
        # Collect output files
        output_files = []
        for pattern in ['*.out', '*.gsc', '*.logo', '*.aln']:
            output_files.extend(list(Path(job_dir).glob(pattern)))
        
        result_files = []
        for f in output_files:
            try:
                content = f.read_text()
                result_files.append({
                    'name': f.name,
                    'path': str(f),
                    'content': content
                })
            except:
                result_files.append({
                    'name': f.name,
                    'path': str(f),
                    'content': '[Binary file]'
                })
        
        return {
            'status': 'success',
            'stdout': result.stdout,
            'stderr': result.stderr,
            'files': result_files,
            'command': ' '.join(cmd),
            'job_id': job_id,
            'job_dir': job_dir
        }
        
    except subprocess.TimeoutExpired:
        return {
            'status': 'error',
            'error': 'Job timed out (max 10 minutes)',
            'job_id': job_id
        }
    except Exception as e:
        return {
            'status': 'error',
            'error': str(e),
            'job_id': job_id
        }