% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

% Next we take a snapshot from the camera
 img = snapshot(cam);

% Show the snapshot
 imshow(img)