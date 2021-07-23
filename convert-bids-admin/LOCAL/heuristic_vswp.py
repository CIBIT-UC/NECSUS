import os


def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_run-0{item:01d}_T1w')
    task_inner = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-innerspeech_run-0{item:01d}_bold')
    task_overt = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-overtspeech_run-0{item:01d}_bold')

    info = {
                t1w: [],
                task_inner: [],
                task_overt: []
            }

    for idx, s in enumerate(seqinfo):
            if ('MPRAGE_p2_1mm_iso' in s.protocol_name):
                info[t1w].append(s.series_id)
            if ('Inner_speech' in s.protocol_name):
                info[task_inner].append(s.series_id)
            if ('Overt_speech' in s.protocol_name):
                info[task_overt].append(s.series_id)
    return info
