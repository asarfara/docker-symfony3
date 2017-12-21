<?php

namespace AppBundle\Controller;

use Doctrine\DBAL\DriverManager;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function indexAction(Request $request)
    {
        $em = $this->getDoctrine()->getManager();

        $query = "show databases";

        $statement = $em->getConnection()->prepare($query);

        $statement->execute();

        $resultDatabase1 = $statement->fetchAll();

        print_r($resultDatabase1); die();

        // replace this example code with whatever you need
//        return $this->render('default/index.html.twig', [
//            'base_dir' => realpath($this->getParameter('kernel.project_dir')).DIRECTORY_SEPARATOR,
//        ]);
    }
}
