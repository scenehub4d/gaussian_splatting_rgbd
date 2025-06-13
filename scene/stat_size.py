from rgbd_processor import RGBD_Processor
from geometry_processor import Ptcl_Processor


intrinsic_path = f"/shiraz/final_IMC_3D/intrinsics/{scene_type}_config.json"
extrinsic_path = f"/shiraz/final_IMC_3D/extrinsics/global_extrinsics_{scene_type}_scaniverse_aligned.npy"

cam_idx_list = [0, 1, 2, 3]  # Assuming we have 4 cameras indexed from 0 to 3

rgbd_processor = RGBD_Processor(cam_idx_list=cam_idx_list, 
                            extrinsic_path=extrinsic_path, 
                            intrinsic_path=intrinsic_path)
frame_idx = 1

rgbd_processor.load_images(images_folder, frame_count=100, test_idx=frame_idx)
    