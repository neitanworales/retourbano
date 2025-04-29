<?php
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    return 0;
}

require './RetoUrbanoDao.class.php';
$datos = RetoUrbanoDao::getInstance();

$role_requiered = ['admin'];

if (empty($_REQUEST['user']) or empty($_REQUEST['token']) or empty($_REQUEST['opcion'])) {
    http_response_code(400);
    $response["error"] = "true";
    $response["mensaje"] = "Bad request";
    echo json_encode($response);
    exit;
}

$user = $_REQUEST['user'];
$token = $_REQUEST['token'];

if (!$datos->validarToken($user, $token) or !$datos->validarAdmin($user)) {
    http_response_code(401);
    $response["error"] = "true";
    $response["mensaje"] = "No authorizado";
    echo json_encode($response);
    exit;
}
$isAdmin = true;
$opcion = $_REQUEST['opcion'];

switch ($opcion) {
    case 1:
        $status = $_REQUEST['status'];
        $staff = $_REQUEST['staff'] == 2 ? "T" : $_REQUEST['staff'];
        $admin = $_REQUEST['admin'] == 1 ? "1" : "0";
        $byname = $_REQUEST['byname'];
        $seguimiento = $_REQUEST['seguimiento'] == 1 ? "1" : "0";
        $arrayResponse['resultado'] = $datos->consultaGuerreros($status, $staff, $admin, $byname, $seguimiento, $isAdmin);

        $number = 1;
        foreach ($arrayResponse['resultado'] as &$valor) {
            $valor["numero"] = $number++;
            $pagos = $datos->getPagos($valor['id']);

            foreach ($pagos as &$pago) {
                $pago['nuevo'] = false;
                $pago['actualizar'] = false;
            }

            $valor['pagos'] = $pagos;

            $valor["staff"] = $valor["staff"] == "true";
            $valor["admin"] = $valor["admin"] == "true";
            $valor["confirmado"] = $valor["confirmado"] == "true";
            $valor["asistencia"] = $valor["asistencia"] == "true";
            $valor["seguimiento"] = $valor["seguimiento"] == "true";
            $valor["emailEnviado"] = $valor["emailEnviado"] == "true";
            $valor["emailConfirmado"] = $valor["emailConfirmado"] == "true";
        }

        echo json_encode($arrayResponse);
        break;
    case 2: // cambio de status
        $status = empty($_REQUEST['status']) ? "Z" : $_REQUEST['status'];
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        if ($id == 0) {
            $response["error"] = "true";
            $response["mensaje"] = "error de id";
            echo json_encode($response);
        }
        if ($status <> 'A' && $status <> 'B') {
            $response["error"] = "true";
            $response["mensaje"] = "error de valor de status " . $status;
            echo json_encode($response);
        } else {
            $datos->changeStatus($id, $status);
        }
        break;
    case 3: // cambio de staff
        $staff = $_REQUEST['staff'];
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        if ($id == 0) {
            $response["error"] = "true";
            $response["mensaje"] = "error de id";
            echo json_encode($response);
        } else if ($staff <> '1' && $staff <> '0') {
            $response["error"] = "true";
            $response["mensaje"] = "error de valor de staff";
            echo json_encode($response);
        } else {
            $datos->changeStaff($id, $staff);
        }
        break;
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 14:
        $arrayResponse['resultado'] = $datos->getIndicadores($opcion);
        echo json_encode($arrayResponse);
        break;


    case 9: // cambio a admin
        $admin = $_REQUEST['admin'];
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        if ($id == 0) {
            $response["error"] = "true";
            $response["mensaje"] = "error de id";
            echo json_encode($response);
        } else if ($admin <> '1' && $admin <> '0') {
            $response["error"] = "true";
            $response["mensaje"] = "error de valor de admin";
            echo json_encode($response);
        } else {
            $datos->changeAdmin($id, $admin);
        }
        break;

    case 10:
        $newPassword = $_REQUEST['newPassword'];
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        if ($id == 0) {
            $response["error"] = "true";
            $response["mensaje"] = "error de id";
            echo json_encode($response);
        } else if (empty($newPassword)) {
            $response["error"] = "true";
            $response["mensaje"] = "error de valor de cambio";
            echo json_encode($response);
        } else {
            $datos->changePassword($id, $newPassword);
        }
        break;
    case 11:
        if (empty($_REQUEST['year'])) {
            http_response_code(400);
            $response["error"] = "true";
            $response["mensaje"] = "Year param is neccessary";
            echo json_encode($response);
            exit;
        }
        $year = $_REQUEST['year'];
        $response['resultado'] = $datos->consultaGuerrerosHistorial($year);
        $response["mensaje"] = "Ok";
        $response["year"] = $year;
        echo json_encode($response);
        break;
    case 12:
        $response['resultado'] = $datos->obtenerHospedajes();
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    case 13:
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        $habitacion = empty($_REQUEST['habitacion']) ? "0" : $_REQUEST['habitacion'];
        $response['resultado'] = $datos->updateHospedaje($id, $habitacion);
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    case 15:
        $usuarios = $datos->getUsuarios();
        foreach ($usuarios as &$usr) {
            $rolesQuery = $datos->obtenerRolesById($usr['id']);
            $roles = array();
            foreach ($rolesQuery as &$rol) {
                array_push($roles, $rol['rol']);
            }
            $usr['roles']=$roles;
        }
        $response['users'] = $usuarios;
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    case 16:
        $guerrerosRepetidos = $datos->getGuerrerosRepetidos();
        foreach ($guerrerosRepetidos as &$gr) {
            $campas = $datos->getGuerreroCampamentosByEmail($gr['email']);
            $campamentos = array();
            foreach ($campas as &$camps) {
                array_push($campamentos, $camps);
            }
            $gr['campamentos']=$campamentos;

            $tutoria = $datos->getTotoriaByEmail($gr['email']);
            $tutorias = array();
            foreach ($tutoria as &$tuts) {
                array_push($tutorias, $tuts);
            }
            $gr['tutorias']=$tutorias;
        }
        $response['resultado'] = $guerrerosRepetidos;
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    case 17:
        $id = empty($_REQUEST['id']) ? "0" : $_REQUEST['id'];
        $email = empty($_REQUEST['email']) ? "" : $_REQUEST['email'];
        $email_tutor = empty($_REQUEST['email_tutor']) ? "" : $_REQUEST['email_tutor'];
        $response['resultado'] = $datos->updateTutoria($id, $email, $email_tutor);
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    case 18:
        $email = empty($_REQUEST['email']) ? "" : $_REQUEST['email'];
        $password = empty($_REQUEST['password']) ? "" : $_REQUEST['password'];
        $response['resultado'] = $datos->updatePassword($email, $password);
        $response["mensaje"] = "Ok";
        http_response_code(200);
        echo json_encode($response);
        break;
    default:
        $response["error"] = "true";
        $response["mensaje"] = "ninguna opcion seleccionada";
        echo json_encode($response);
        break;
}
?>