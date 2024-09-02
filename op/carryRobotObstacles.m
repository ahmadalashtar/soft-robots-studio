function [tempObsNTargets,angle] = carryRobotObstacles(i, end_effector, robot_orientation, length,tempObsNTargets,length_domain,angleDomain,obstacles_n_targets,firstAngleIsFixed,one,obsAmount)
    
    global algorithm;

    prevFunc = dbstack(1).name;
    
    tempObsNTargets(1:obsAmount, 3) = tempObsNTargets(1:obsAmount, 3) + obstacles_n_targets(obsAmount + i, 3)*2;

    tempObsNTargets(obsAmount+i+1:end, 3) = tempObsNTargets(obsAmount+i+1:end, 3) + obstacles_n_targets(obsAmount + i, 3)*2;

    tempObsNTargets(obsAmount + i,:) = [0, 0, 0];
    switch algorithm
        case 'ga'
            switch prevFunc
                case "generateRandomChromosome"
                    if ~one
                        angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets,angleDomain,false);
                    else
                        if firstAngleIsFixed
                            angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets,[-abs(angleDomain) abs(angleDomain)],false);
                        else
                            angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets, [-179 180], false);
                        end
                    end
                case "blendCrossover_obstacleAvoidance"
                        angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets, angleDomain, false);
            end
                    
                    
        case 'bbbc'
            switch prevFunc
                case "generateRandomChromosome"
                    if ~one
                        angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets,angleDomain,false);
                    else
                        if firstAngleIsFixed
                            angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets,[-abs(angleDomain) abs(angleDomain)],false);
                        else
                            angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, length, length_domain, tempObsNTargets, [-179 180], false);
                        end
                    end
            end
    end


    tempObsNTargets(1:obsAmount, 3) = tempObsNTargets(1:obsAmount, 3) - obstacles_n_targets(obsAmount + i, 3)*2;
    if i ~= size(tempObsNTargets,1)
        tempObsNTargets(obsAmount+i+1:end, 3) = tempObsNTargets(obsAmount+i+1:end, 3) - obstacles_n_targets(obsAmount + i, 3)*2;
    end
end