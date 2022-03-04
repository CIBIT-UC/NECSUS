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
    retinotopy = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-retinotopy_run-0{item:01d}_bold')
    glare = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-glare_run-0{item:01d}_bold')
    noglare = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-noglare_run-0{item:01d}_bold')

    info = {
                t1w: [],
                retinotopy: [],
                glare: [],
                noglare: []
            }

    for s in seqinfo:
        """
        The namedtuple `s` contains the following fields:

        * total_files_till_now
        * example_dcm_file
        * series_id
        * dcm_dir_name
        * unspecified2
        * unspecified3
        * dim1
        * dim2
        * dim3
        * dim4
        * TR
        * TE
        * protocol_name
        * is_motion_corrected
        * is_derived
        * patient_id
        * study_description
        * referring_physician_name
        * series_description
        * image_type
        """
        if ('t1_mprage_sag_p2_iso' == s.series_description) and ~s.is_motion_corrected:
            info[t1w].append(s.series_id)
        if ('retinotopia_8bar_Run1' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 180):
            info[retinotopy].append(s.series_id)
        if ('retinotopia_8bar_Run2' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 180):
            info[retinotopy].append(s.series_id)
        if ('retinotopia_8bar_Run3' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 180):
            info[retinotopy].append(s.series_id)
        if ('Glare_Run1' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 177):
            info[glare].append(s.series_id)
        if ('Glare_Run2' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 177):
            info[glare].append(s.series_id)
        if ('NoGlare_Run1' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 177):
            info[noglare].append(s.series_id)
        if ('NoGlare_Run2' == s.series_description) and ~s.is_motion_corrected and (s.series_files == 177):
            info[noglare].append(s.series_id)

    return info
