import {createActor, proprium_minter_backend} from "../../declarations/proprium_minter_backend";
import {AuthClient} from "@dfinity/auth-client"
import {HttpAgent} from "@dfinity/agent";
import * as PROPRIUM from 'proprium-js';

const ID_PROVIDER = process.env.II_URL;
const MINTER_BACKEND = process.env.PROPRIUM_MINTER_BACKEND_CANISTER_ID;

const SCENE =  new PROPRIUM.HVYM_DefaultScene();
SCENE.createCameraOrbitControls();

const ORIGIN = new PROPRIUM.InvisibleBox(SCENE.scene).box;
SCENE.setOrigin(ORIGIN);
ORIGIN.name = "ORIGIN";
const IC_MINTER = SCENE.addICModelMinterClient( './test.glb', AuthClient, HttpAgent, createActor, ID_PROVIDER, MINTER_BACKEND, true);


SCENE.scene.add( ORIGIN );

SCENE.animate();


