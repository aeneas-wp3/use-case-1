# use-case-1
AENEAS WP3 Processing Use Case 1: Calibration and Imaging

- Run setup_prefactor_here.sh to setup the environment, create standard parsets for calibrator and target, and a run script
- Place your calibrator and target data in the directories created : cal_data_in and target_data_in respectively
- Update the cal_input_pattern and target_input_pattern parameters in the respecective parsets if needed
- Run the run.sh that the setup script created

Other parsets included require the user to replace the TRUE_HOME qualifier with their current working directory and are better suited to distributing the computing load. 
They can be run similar to the standard parsets
genericpipeline.py -v -d -c pipeline.cfg Pre-Facet-Calibrator-1.parset
